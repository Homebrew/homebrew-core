class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "7946375551179ffc374860f988fca04503c0c7ebfd03ad7edc66431de0e68f14"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69f188bfebe9ad7837c794e2441e06f9da100ac1151921bfe25dc60cead3142d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f2c8b776505591b64b19bd5835bd3e470993613969ec2af70c9be405bd0051c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0078f26841463e4846a8583dadb57c6518d7892165154ec6298a38e798b4bd2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "539f0f29836c8ee88d845d783080e18768090283475f8413d2862f9690448db1"
    sha256 cellar: :any_skip_relocation, ventura:       "3d785ef514495ed8c6d6320f88e2ae5f20a6de3649a00473d1ba8c6ecd2d93ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207ed05bf3fe39e0e8b2853a830e2437a82add5e46e6119a83f7b523256a4f41"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
