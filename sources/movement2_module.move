module origin_byte_game::movement2_module {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct Vector2 has copy, store, drop {
        x: u64,
        y: u64
    }

    struct PlayerState has key {
        id: UID,
        position: Vector2,
        velocity: Vector2
    }

    struct PlayerStateUpdatedEvent has copy, drop {
        position: Vector2,
        velocity: Vector2
    }

    public entry fun create_playerstate_for_sender(ctx: &mut TxContext) {
        let state = PlayerState {
            id: object::new(ctx),
            position: Vector2 {
                x: 100000,
                y: 100000
            },
            velocity: Vector2 {
                x: 100000,
                y: 100000
            }
        };
        transfer::transfer(state, tx_context::sender(ctx));
    }

    public entry fun do_update(self: &mut PlayerState, posX: u64, posY: u64, velX: u64, velY: u64) {
        use sui::event;

        // TODO some validation
        self.position.x = posX;
        self.position.y = posY;
        self.velocity.x = velX;
        self.velocity.y = velY;

        event::emit(PlayerStateUpdatedEvent { position: self.position, velocity: self.velocity, })
    }
}