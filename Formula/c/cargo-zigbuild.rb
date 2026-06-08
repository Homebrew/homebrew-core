class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "95aee6c02f3d9ca7472cb82607fc0469173dc66749208e725ff05f1c4c04d4d0"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b37a2abc6ede87d1a6b3cb514cfb0f487fe5459a2de8facf6390fce74566133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "635f6d346227e0a4bc3db6b4074c04a79b548f57ce6c78cb584149f1521e0809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c335fdbf508295a9d582dfd4cdb7985b963644debedf940bcfc8bc56e2dad61e"
    sha256 cellar: :any_skip_relocation, sonoma:        "14b11d8c9bca57d7ef8ea9deb3d89ad399d4ec740fb27d3c46a6150eebc4915e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d24e6beeab313aff3d22ddba04012e44dc534cf9e842da26958bb057f89b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffeb2e5f6b0253f0671e9cacb5eae2f2ece1fb3b40707579d721530571254c9d"
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
