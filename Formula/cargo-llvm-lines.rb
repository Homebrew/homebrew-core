class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.18.tar.gz"
  sha256 "9c53696283690b9225defbc11f79a4f9d019e9b8ac3a1429231c2962bc703291"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bb1bade816961eb1b489cb51690dd155df97a2f6168ea52fefe51004c77bd10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ab47f79140ecdd4f368bc0810c7c6cec7ba67f08554b6077e430004dab93223"
    sha256 cellar: :any_skip_relocation, monterey:       "3ca8656c2c3f4912701f4c319b2fc1ca6fc80d87316322a135b571c425bfefb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "792387e15636134531c7ce8542d8d93912515589e457f153342f0a6b7aa56a00"
    sha256 cellar: :any_skip_relocation, catalina:       "a99101c2c41388163ac40b3addedbfe4363a4a20157a3a26eb30c6eeb2a812a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257ea5e78ac334bbef0f6f784d50b018e91765af78e8c216cc059f82d62fb4c9"
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
