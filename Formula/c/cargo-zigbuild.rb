class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "eb2f3b363a110844d5a85005cb83b2cb83f7dc38fafd02ee4de20fd32a5f4884"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88de0358872e85e8fcaa05302a186b6cb1050f4cde14d7b54a5e6721989e8df3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cffacbbac5b8e00da8a81da4c8f2f84570e4801fb4706dda35ff4a97fce9d8fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63dbf7f0a0136f5e3c60afbb1b7f171f3efeb63af0569550b03f29e33ba5d7eb"
    sha256 cellar: :any,                 arm64_linux:       "3efc79220148a1dda0d7abd5c581cf3c02e310b1fd6d4419fdf539dc8ec758c5"
    sha256 cellar: :any,                 x86_64_linux:      "d34b88bcb6e8c3ca25e8aa2897acf813842051162ee2002adda8724c024a4ae3"
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
