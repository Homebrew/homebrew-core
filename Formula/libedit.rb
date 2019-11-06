class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20191025-3.1.tar.gz"
  version "20191025-3.1"
  sha256 "6dff036660d478bfaa14e407fc5de26d22da1087118c897b1a3ad2e90cb7bf39"

  bottle do
    cellar :any
    sha256 "c7cc54cea12647c6f0fe804e3e85768e3a861d170789bfe53c07cde186dfcdd8" => :catalina
    sha256 "bb80053d3becbb175049265573c5905641ba2f1fe4db357f7a168d14da489925" => :mojave
    sha256 "14505d667f2efb073f9b5258e3ab5a7ca8bfd3dcf611c0ed151005fa1221bca8" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
