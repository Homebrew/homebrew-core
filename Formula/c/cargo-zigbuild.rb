class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "47c2964464d7083fb53dd5feda6d2dae39346bd0f8f35d4a31c558e100e1c557"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af5da4384db197c4fd9f58afcd0bca36e7442b20785646256bd76444d4b937e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1f781493e06b04c5cd878cc1387bbfec4c1a767505d579386ea354c276725a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb9ca49fafef619b115b461eb6541c5dbd700c91861b50e7794409530e50047"
    sha256 cellar: :any_skip_relocation, sonoma:        "656140a8d2f8aef82f7b26d218b0125c69a560778fe3fa98232201da85a76b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71bcb6c332959f1802a65ce1113239c771841148ddde49ce64d4e1edac40f642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ae5f06dc175d78a1321050436e69a2eef38189be77b3086f82d63f52b839aa"
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
