class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "4983fa480a6446e153543bb2b1de00c26098f3361aa6a6a021586915c1c6dcbb"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91a61ce8596ad58c59338cadf8e0c670dba4b695dd1100c3454aabe4e7b4629d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e7bb60a569c4c78e52c4ebe62cd5746d23227ce9e7f0b8c597b2c3e0fd9a037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9f140cbf8a21c999f33027fa3049946e81fa56a87c8cab4ec3095f9fa1e14ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca17d99e4a047ba906292c3b6c68d16391f69d57e8ccf9622c349ac8ef7fbb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060aab76fd3a03a3174ac766b53cab73e9efc975a80bb97a9ca52643a0405008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be7772df41f6710f8a4e06a4f67f7afd831a0fb30a1b4b4e69c81a2f77dbd71"
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
