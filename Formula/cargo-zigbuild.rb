class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "ebfc5a2462626082d2c784e735c038a9e174abbe0b20b9d2cb185add125ee95a"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f3f693fca4cdb2860b7698b59dadca58f76d3a392621b7bc959fa9da8a75c6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b65f8d819b64c46137644c4fc92f8a3eafe28f828b25034c1684927e884bb676"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b7f920f96f69a120b656e5e73d13e090e3289910e208e3031f72c2685ded79d"
    sha256 cellar: :any_skip_relocation, ventura:        "191320fba3e6ec57a3a66b022fdaa9d0879baefbf35856dba45bc18b7065ef03"
    sha256 cellar: :any_skip_relocation, monterey:       "23a2fe5231c45a297ad2c0d8667ef39a7034105a9b0f26f9646ff741359e0b1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "04a3127a9c39ff24e5fcedc09f9881037c5e0dd63d3b0ed67a59946020f54202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74014c8a082188c3d2fab7f4c50b161058fc9f65d5e987bce96240860b838b83"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end
