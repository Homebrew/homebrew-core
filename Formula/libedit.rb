class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "http://thrysoee.dk/editline/"
  url "http://thrysoee.dk/editline/libedit-20160903-3.1.tar.gz"
  version "20160903-3.1"
  sha256 "0ccbd2e7d46097f136fcb1aaa0d5bc24e23bb73f57d25bee5a852a683eaa7567"

  bottle do
    cellar :any
    sha256 "7a3c159ac3c22df47788b27cb10260b27ed39a8e20a3e7c1fc1d4d843f3c08ca" => :sierra
    sha256 "620192dd5489c9521c68f5354679de3d19053724228784ec4837181026bf761e" => :el_capitan
    sha256 "b1ef895bf1565b8d4d3a63fcaf8ef930d2e3a60bbfc9cef21ecea672e0bd3217" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-widec",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
