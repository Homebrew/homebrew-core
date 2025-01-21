class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.6.tar.bz2"
  sha256 "e731a262aeecdf4e3d5ccdd8c73b832749b1277078464ea7697adba26e6e6bb6"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd6a1c317c19f101b9e47ecb0bc02437884d15b16f6b99ba2111b9b062c4f6e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "080debd9482218cbbdb352939bed48e4097ac967b4b9685a0f0368d8be582298"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b0016db95a3807c8c1657eaa14ac2f716400b40c08930dc8910a7aa0d38c45b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0972547cb42972453fcd2ca15f586792f3e028a1f6471afe0e44bf21ad33509b"
    sha256 cellar: :any_skip_relocation, ventura:       "36189a40f4b15d4bd8401c56ec62437f139301649982ad1ae4a91184ce7576b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef7e3866424d0831c0c4615bf061b24dbcb93369005dd8765a6468ff07c2537"
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
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end
