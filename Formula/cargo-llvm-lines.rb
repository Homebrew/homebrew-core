class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.18.tar.gz"
  sha256 "9c53696283690b9225defbc11f79a4f9d019e9b8ac3a1429231c2962bc703291"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08bb2acad93563abcb8c5611f968b22ad31ac01d65bf8ba1b49367c9783b6cb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85531be7ded6c36c9490e996e191191a6e1c98f5c37f9e8090173fa98027c085"
    sha256 cellar: :any_skip_relocation, monterey:       "b86857522dcd390a87995b4229107c40e726aa90f14a22fb010db29a4a5db0a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8f9498d4444bb55add07970fc6cd8addfa571adede3b5417a54dab9225fb8ca"
    sha256 cellar: :any_skip_relocation, catalina:       "596fc839fb6fb14ed5890aaa343dca60076e9577c86ba9067587202a4fac4107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09af993b89755b5376db4a392fd40e8a9c5db42e04b338c109a5d725364f6c5b"
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
