class Libfastjson < Formula
  desc "Fast JSON library for C"
  homepage "https://github.com/rsyslog/libfastjson/"
  url "http://download.rsyslog.com/libfastjson/libfastjson-0.99.8.tar.gz"
  sha256 "3544c757668b4a257825b3cbc26f800f59ef3c1ff2a260f40f96b48ab1d59e07"

  depends_on "pkg-config" => :build

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
      #include <json.h>
      int main() {
      printf("%s\\n", fjson_version());
      return 0;
      }
    EOS

    cflags = `pkg-config --cflags libfastjson`.split(" ")
    system ENV.cc, "test.c", *cflags, "-L#{lib}", "-lfastjson", "-o", "test"
    system "./test"
  end
end
