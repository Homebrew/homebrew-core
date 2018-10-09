class Liblognorm < Formula
  desc "Log normalizing library"
  homepage "http://www.liblognorm.com/"
  url "http://www.liblognorm.com/files/download/liblognorm-2.0.5.tar.gz"
  sha256 "c8151da83b21031f088bb2a8ea674e4f7ee58551829e985028245841330db190"

  depends_on "pkg-config" => :build
  depends_on "libestr"
  depends_on "libfastjson"

  def install
    ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "-prefix=#{prefix}",
                          "--libdir=#{lib}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "stdio.h"
      #include <liblognorm.h>
      int main() {
      printf("%s\\n", ln_version());
      return 0;
      }
    EOS

    cflags = `pkg-config --cflags lognorm`.split(" ")
    system ENV.cc, "test.c", *cflags, "-L#{lib}", "-llognorm", "-o", "test"
    system "./test"
  end
end
