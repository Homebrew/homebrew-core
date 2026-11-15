class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.24.tar.bz2"
  sha256 "972034b036e387de23639b796a06826d78a2c8646be3454b60e48af138e90336"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01ee5d719dc22619e7875e553b7ac447520a7c359bbea002149c87c530017247"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c9148250f71df7db51c5b17815455252b1d38df58c22a6e37084570e555f1ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5997036d1d610fa13018de8f58d2eddfe099aad923bdfd0d24d272f2b1e4610"
    sha256 cellar: :any,                 arm64_linux:       "bd8d858ef661713f182d498fd4b7320be1dcd8bee0ce3cd14bf5faaf14d7093e"
    sha256 cellar: :any,                 x86_64_linux:      "b4c6dbc81998bb124ba692e5192bc08286a30858172339367da25095347c61ee"
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
