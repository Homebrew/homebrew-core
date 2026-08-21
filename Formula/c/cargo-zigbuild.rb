class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "11fc27d15d3981fb1aee90a313fd3f16fc6e0699b2293f0bb4dfde4a42d1dd9c"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e41af52e5149f009e055fa39bc32bfb9adea7c93786e9fbc1ab6d063b4048c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ff2209e63f27266a02ebe922a694449264e4d8c177c6ba6253cb760bdf0c5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b2188f731bd0b8352ec6f5d99cf66c429283aaa5d162a6989fb1e0a9a45904a"
    sha256 cellar: :any_skip_relocation, sonoma:        "628dc47f5bc4e3906793caa43d61bf54a946b51bba88a7886eb6ac547b741302"
    sha256 cellar: :any,                 arm64_linux:   "b82056e43985a5bf4b9e26607a9165a38ebc3357818161334dbaaf7f8eaea936"
    sha256 cellar: :any,                 x86_64_linux:  "41d28982e8fb5c5c08cc998b2979ce72a5728387d34eec5b8171c677498161d2"
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
