class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "fac87bf9e3ffbc4c265f9ac257f880f63e6168510acd482833a148b0f7c05b37"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a62f688aa7ad048d1da16367f9a6ea0dbfc7abaa5efe378cc4e36b18cb879c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99ad4727b3dbe2cf1018fb5e5f1b5c8235325a8a32bf91fee2c8f2aebd7f8069"
    sha256 cellar: :any_skip_relocation, ventura:        "e2d959a4f3274e8d50de98e872f92359c69ae89e298aba10a1e7d923e566f2c2"
    sha256 cellar: :any_skip_relocation, monterey:       "1188c15d615fda5b60c54368c24dcbf9ce4d4a02620a00f2b2d2281c177174df"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce9dc25ba1195db6c7e15bef9aa72650009f1fb9c7426591082c344af8155b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71c25abfe051d3fc931bb90cfa2bf1189e19c0140f73ca5a34a3b7fef3e8a6c"
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
