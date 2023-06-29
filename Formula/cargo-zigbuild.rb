class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.11.tar.gz"
  sha256 "7bea3d74cc646d9a191b80035c6800c28aff1d0f4cd3e77ec98db68e333d5a6f"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b54aff8d528d1f79b7cdc825223ce47e2ecdf474fbae55df4391c2f8c3eb30a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0dd07208913987f5b368f3f009dd2c7ba35676e28d06a572c8036e16306a63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "351ae77e1b9205435716c4c328ec5e0c992382807095d3be6189957457441cb3"
    sha256 cellar: :any_skip_relocation, ventura:        "f40cb142f1ecbf9a6bd2c3e6d0494fa04a24a1c4266aeda2513c17bacdf6d730"
    sha256 cellar: :any_skip_relocation, monterey:       "0d59037d80f8c902b04a015849c7bab68cef40d89ae94f7bb3ec424e447f8792"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bbbeb55f989131b60f773c6a959f7e6f72cdece24e360de7b61a348a2d0f13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c3fa7b3fecc9f9e96c94f6116346868b523f4cadd1ee611abb4f07e702ddc3"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
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
