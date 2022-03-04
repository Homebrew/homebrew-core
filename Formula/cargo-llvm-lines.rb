class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.14.tar.gz"
  sha256 "1dc5a726b3b7b3ac2d01e190e605415b394c95cc44144fb91ddea643d35eda78"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f44344cd46313f253c627378a2c6400e411441c006b296c52e91e901fbd2db0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a65381b213e00659b607510c1b7c47936b5c00ecb866c3b12125613a0342f138"
    sha256 cellar: :any_skip_relocation, monterey:       "7eb816e4f36af73a944f961cc986bdc5f02b117629a15d18303ed059b14e5816"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf0d8a83e05e0a08784522511e1c0922dcb8d4970c460d7c9a187d313f4cc2ce"
    sha256 cellar: :any_skip_relocation, catalina:       "a4990d361b4daeb28180133aebf9c3abf0fdd3add46b6203f78ad227b90bab45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "404c745037e9002aea385862499b85a2a411c568b8e8f0d901b785ee2198833c"
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
