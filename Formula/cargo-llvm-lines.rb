class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.19.tar.gz"
  sha256 "1da2987f228187c77bd19ca8c1f5616b00736e7094f4ac8588e23decbcfdde7b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c110e9a94ac08f31c331325e6688330ec4c5d3c605c4474e789118f6ab92de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01e690d541c19126ce8d8aab62e9f7b6ff001f63f99fd6e1a76374963f18889f"
    sha256 cellar: :any_skip_relocation, monterey:       "279ac092432fa38e07a193eddb5da58102c5ca1ea20f761e35ad6e0917d81de3"
    sha256 cellar: :any_skip_relocation, big_sur:        "795d7c0432927c9f1d5944565038cda52f7b2ddd49bbcbf07cacbaf7859a0ad2"
    sha256 cellar: :any_skip_relocation, catalina:       "d515fd7c79d113a7cb349be34506c8c5a0062b8fac16c815592d59c438a64d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe598e55cea37814d9a4ea0aa0b02b566b97791cfd3cf7090b0c1a88c41d2d5"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
