class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.13.tar.bz2"
  sha256 "78a610abd39e94e0f913e9ee5cda1e85bb62cd633553decb9e00d3d9201019ce"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8752a9e563685ba70cfa94b692b0e6b312b8f31586927442ed52b39ab375d7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168d3a591b56816d6b07fd77caf153e1c50249f66f622c1f29cc741b553934ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76a699d10c2b3ba613f32a78c335a7226239033ce58b72269d10d784defed2f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd4f277b2fc5ef4b56e7f092a9bdda987d21bb5dc666484c52493a9d5aef6a7f"
    sha256 cellar: :any_skip_relocation, ventura:        "719e8b8c846f17e285593336979cf177a9b392cc8104aa3c055c21cddcf5ae64"
    sha256 cellar: :any_skip_relocation, monterey:       "01aef09fef4c53619c12b6ccb517ea72e15e1ddb64bd054ea0626052134e953c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9407606901842fcbc5ed0853a3ea7c352bbc288a3eee4dcc960516e40fae8b"
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/gcc/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
