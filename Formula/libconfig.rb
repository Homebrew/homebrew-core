class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.7.1.tar.gz"
  sha256 "d288e6ae817f4ef78df43cdb2647f768dc97899ee82fcc41f857e8eb9fd7fbdb"
  head "https://github.com/hyperrealm/libconfig.git"

  bottle do
    sha256 "393d13238b0259162bca7c1f61cc56f96370b3e84db24609bbcab6913bd6ac1e" => :high_sierra
    sha256 "bb0326e6418c46f2c387e6e161e859d19e26efeefb86101d6056c66047f14523" => :sierra
    sha256 "7f3cd7d160f43c050d05c462cb56ef8a31db13f06de7507b305a7cc14d244d65" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lconfig",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
