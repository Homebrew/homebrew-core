class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.21.tar.gz"
  sha256 "2263ce6a8109d03a07ecf7911cfed37c02c7451c7288f7bec1ec6271e84523df"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90e60996c9cc00b86f0bc282792d04731f770020f1f197e78f6f381e99d49b2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31ac30a5bb7ab4875de07a91a037100c5542aa1fed660540a56606b7f530a572"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb8b6fa1e60b7768c78b6da8e486150af942c1a2b55b34cb79817fd77c2eb7de"
    sha256 cellar: :any_skip_relocation, monterey:       "9f22eae766c2706a0509e345c761e25b38b87741b15193fea7bad8bef0c984c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "57693bcf1679794563e438bd922f9390f8dee5dde47c31c510b47b6a9d59c2d7"
    sha256 cellar: :any_skip_relocation, catalina:       "e475c0b8a6ff6b03c7e842fc9f63fc6d8a989833920446c0c3a60213ff916d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71cb92467c052bec994fdfd4b9c98abb7cde881cb70525c84155ecfc8aec9f17"
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
