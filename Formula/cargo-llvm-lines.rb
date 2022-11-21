class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.21.tar.gz"
  sha256 "2263ce6a8109d03a07ecf7911cfed37c02c7451c7288f7bec1ec6271e84523df"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "421a65ae84c466255ea2ec6848f4e636caef85b6e6f1d179c97695c8b745e223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c543b37bca92a13c3c30eb70d7f84defaf43a1a4352bd39f85817b927cafc680"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d2b2ce7fdae470496cefdd0a086c1ffe26b07ec1d6fa8ae2d78ae982268d671"
    sha256 cellar: :any_skip_relocation, monterey:       "22aff3823d678159866598e24f7d9adac9eea69c983b1c2d522b1affbb4e66d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "35421a80098d7c8d5d68361c956ed2291b9425bb83b722da2f183fb892fc129e"
    sha256 cellar: :any_skip_relocation, catalina:       "fe5f7035f068743843ea1760c821e7502cb400a33e9f7af18b6d374fa875d7b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a418669e33e45965aa1e4a9d816736cc93633f3976329b0b56e4667335e7ff"
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
