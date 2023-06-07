class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.10.tar.gz"
  sha256 "d4386e4ec7ac93ac396cbc67fa226f62cc62f9d2c1b8c9dd9b229e051121c79f"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82de94cc2c1b01946c69578547cbbdbaa7aed6cb60ebb2906beef0941c3e4933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b776116168693882ac975fd883ed3111cee33a67dba8d32fd40169b8e0037b9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e38326816597af242e5b41834b7a4fc154ae71a2c817530ede2626b5c8e6cbf"
    sha256 cellar: :any_skip_relocation, ventura:        "18cd0cd2b3dbe825f5a77ef6ee32c01ea5ee86319b549b28081d09b31f17278e"
    sha256 cellar: :any_skip_relocation, monterey:       "abbf2a2cc00f2b1b7cd9bc1a1487874c99ee59d4ac127feecfcd56773c1e06e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1e02837088e35b3e47cd28b14d717618fa588855135a5e02501a036709ea166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a329ab811c83bed1fbe9c79b03e828e41be4e86350f82b4644f2b0a0ad4a37"
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
    # https://github.com/ziglang/zig/issues/10377
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
