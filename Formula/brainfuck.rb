class Brainfuck < Formula
  desc "Interpreter for the brainfuck language"
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.3.tar.gz"
  sha256 "d99be61271b4c27e26a8154151574aa3750133a0bedd07124b92ccca1e03b5a7"
  license "Apache-2.0"
  head "https://github.com/fabianishere/brainfuck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "f52d2a6b20c727834e0aa1dd54180d13e9c1ef27e3aa2c7112f0bbb7b3c50151"
    sha256 cellar: :any,                 arm64_big_sur:  "c7c0b45b6d596c3fd5e83156331b7595521249b34c443518d5a757a937551046"
    sha256 cellar: :any,                 monterey:       "3bc30ee4c21acacd11d589ce31449979c322f4ac3a407abaf9a39a1a6946c543"
    sha256 cellar: :any,                 big_sur:        "7b128f991009e1e9b4e5ce31b451f49d7aaab01b4a7867ce8709483dee4e8bea"
    sha256 cellar: :any,                 catalina:       "e6df5d077a5a75d2f350064f7d8aab3ac109759ca330753f974c9bd23043a917"
    sha256 cellar: :any,                 mojave:         "ede2edc346ff8bfff8829ced2ec99ef0df74edf6978fb2541bbaa7daa53f8d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38510b863336aac8bf1c37a49c74a41451c7cfa7f3cd78de7bc7be27f953f242"
  end

  depends_on "cmake" => :build

  uses_from_macos "libedit"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIB=ON",
                         "-DBUILD_STATIC_LIB=ON", "-DINSTALL_EXAMPLES=ON"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/brainfuck -e '++++++++[>++++++++<-]>+.+.+.'")
    assert_equal "ABC", output.chomp
  end
end
