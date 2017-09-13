class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.0/astyle_3.0_macos.tar.gz"
  sha256 "d113aa5942219699262ceddd1dde35c66b20bf6cc5eac04d27d398ca7a460eb3"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any_skip_relocation
    sha256 "49ed8641bb284828c0e753b6d2570c317f4275a9ee5845c33ac90835dd319258" => :sierra
    sha256 "b5da4fab0010f84a6623585c99e5468492e0a2c8dd1a77680bd4c51b900c0272" => :el_capitan
    sha256 "69819972ffefb908f5186f01b688d32c28e9ea2ca2a0d62c5b2850e686e1aefa" => :yosemite
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<-EOS.undent
      int main()
      {
          return 0;
      }
    EOS
  end
end
