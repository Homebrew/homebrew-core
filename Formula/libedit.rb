class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "http://thrysoee.dk/editline/"
  url "http://thrysoee.dk/editline/libedit-20160903-3.1.tar.gz"
  version "20160903-3.1"
  sha256 "0ccbd2e7d46097f136fcb1aaa0d5bc24e23bb73f57d25bee5a852a683eaa7567"

  bottle do
    cellar :any
    sha256 "aa5bebaa567a011aec09ae73ebac1a41c10b1281bcbda8db6b34856c0ad72fa5" => :sierra
    sha256 "c59f6ef3c9fa7a3936dbd26c8d46c2d99120b320f59716cfa89c8dbd9bf7db66" => :el_capitan
    sha256 "5fb64cf9e71fe11c38bb6f1c69c3254a93bfa78300601904193e8f746809cbfb" => :yosemite
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
