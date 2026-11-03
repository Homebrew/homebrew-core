class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.21.tar.bz2"
  sha256 "2723e43bc0fb453942a394133683222fd85b1143ee6ae0b1f7b5b1db38df31cd"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69a4384518a12d8df713d616aa5cb256586c1216841f832911dc206f46fb5fac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06c42fcded56300110a402d25cf58fe8f20a4423c3b28034b5524d3276a33ef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a1303682edd2d7a4734521e9cff1a71976f2069c676c188674051243fa01fd8"
    sha256 cellar: :any,                 arm64_linux:       "c699db1c8a9092771feefa03f45da79ba9eab6567d5abb64b16da5de61694b08"
    sha256 cellar: :any,                 x86_64_linux:      "2972cac81362a10da56a4ca5ea09cd203342187c47219cec6df6903eaf644b74"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
