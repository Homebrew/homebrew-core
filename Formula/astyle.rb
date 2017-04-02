class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.0/astyle_3.0_macos.tar.gz"
  sha256 "d113aa5942219699262ceddd1dde35c66b20bf6cc5eac04d27d398ca7a460eb3"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any_skip_relocation
    sha256 "00b19ebc8e22131555090f45a62fe8e47bc147cbb6bd20b46126f64ececff0ba" => :sierra
    sha256 "7e80942d28e0b8767f65e4f90c0b783ffaebb5ed31ffc26278ebaf3c50563ca8" => :el_capitan
    sha256 "a3b000b925c1585ef9a5770da73f99a12e650d820a29a482afbe79838f599309" => :yosemite
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
