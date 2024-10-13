class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.3.tar.bz2"
  sha256 "10ed7c8f974ecce35c1778f1616f04ca93c3d3bfc1a017aa251396041b670efc"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad536ea81692c30f9673464842af1bacd552c9f35c89182b115db0fbea8c8497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87f8e2164c3f59912f55821a8df67aced5825af66d0961ec30cccfc6a5e17961"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ec1e3d132175fd17977408f62eb9166ea074e15fb1f0fbbc265c5b27ccecc72"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6459362cf3206806ee923f68864b4fce93492be13df696a560cecaf4d2b423d"
    sha256 cellar: :any_skip_relocation, ventura:       "e801e9bdac7a84fb385976f53cc80eab7cdfecebdadd6717141362c5b0f9901d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a57336148e71215a695ab72252b452300c3a55919094710fb35e40000189d6df"
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
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
