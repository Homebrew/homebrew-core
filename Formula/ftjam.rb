class Ftjam < Formula
  desc "Build tool that can be used as a replacement for Make"
  homepage "https://www.freetype.org/jam/"
  url "https://downloads.sourceforge.net/project/freetype/ftjam/2.5.2/ftjam-2.5.2.tar.bz2"
  sha256 "e89773500a92912de918e9febffabe4b6bce79d69af194435f4e032b8a6d66a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f94287203827dea6ac5031e695c217a48b1b69e939dcd68a489c8477b4100447" => :el_capitan
    sha256 "95490ead99e537713d8c26d1c1bea72b31ea06153a405867ffe83c044593caa0" => :yosemite
    sha256 "554e527a1e52be6ebd9f5f1fbae4e8f648f750a179936e329238dee32b32520a" => :mavericks
  end

  conflicts_with "jam", :because => "both install a `jam` binary"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Jamfile").write <<-EOS.undent
      Main ftjamtest : ftjamtest.c ;
    EOS

    (testpath/"ftjamtest.c").write <<-EOS.undent
      #include <stdio.h>

      int main(void)
      {
          printf("FtJam Test\\n");
          return 0;
      }
    EOS

    assert_match "Cc ftjamtest.o", shell_output(bin/"jam")
    assert_equal "FtJam Test\n", shell_output("./ftjamtest")
  end
end
