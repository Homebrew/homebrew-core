class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "eb2f3b363a110844d5a85005cb83b2cb83f7dc38fafd02ee4de20fd32a5f4884"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5495c5dbcc246e8538e9eaa4536a06c9f8c95643a83ca2cf1ce261c9767c075f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d263c42afe4e7e3ba55080aa7635687f85996b8cd965321adb2340e0d698c763"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "208ff9560a20bd7108c16ca090a91e5bbad648960fcc7ff99933cfdf85851952"
    sha256 cellar: :any,                 arm64_linux:       "0dcb6f3059980201e8740e63ec59a60a0ac9d5cc2fe6ac5389f6c468ccf93ef2"
    sha256 cellar: :any,                 x86_64_linux:      "12df21545b7e390facc4cf73215b25364a80a8e402d81dd2a8f17f040cef2a80"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
