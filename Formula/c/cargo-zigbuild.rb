class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "405a9cfa5160dd7050296408db7286d32eb0cb7bd3992926c113b91b664a8fbc"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f11329fcb3882e1bbf56f03b033c7b7e43c737b6c3d1a31a0b62a2720991007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "079c1ac43e24d8f2d5232c9e18d63ffec7fd12e17fc8cad477e3daf28fa65fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d2b9ed4373d454f0364ee47c3495237d025210cfb0df6acc3abb921a62ed53"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9310fcf5f8a174a657f127945431075abd66db7d7ae9549624638e03eb5234e"
    sha256 cellar: :any,                 arm64_linux:   "a568be31a9825fbe8e6e6b5a2da9fd75b8787b1a57ace2bb8648ef74ceb12fc3"
    sha256 cellar: :any,                 x86_64_linux:  "7ed58bf6ca263bac262aa89cbe583460ab4d663e66c36767248c05546d1d260f"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
