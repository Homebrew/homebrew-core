class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.14.tar.bz2"
  sha256 "1c46fdc22cbe99c603593993b750baa4ca2e0b4c9e4b1d90e2fb60d749d608d0"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "391e6211ece689fc936ae85884bd997188500917fee15a9875278886aa85ee0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e67b20e9967ba6b576bace4908f0873f4c59aaf214e1daa8f3d4ce18e17d93f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b1d849f72127a8d965d8fdbab7cb841122271b8073a81f134b5d24c1d965cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bbacb800f577756d66594094fe7be2cfd4322249cf33015d57786adee7cbda0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21831483abc471695fb3466ce505331ee0fe7b2eed9f95d401c5bc65f264ca0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa4cdc0a6a56ecf53ca9b319c6169cc7820ea0c47589dded2d30cb28e8ea918"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/astyle.1"
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system bin/"astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", testpath/"test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end
