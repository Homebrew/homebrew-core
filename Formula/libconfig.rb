class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.7.1.tar.gz"
  sha256 "d288e6ae817f4ef78df43cdb2647f768dc97899ee82fcc41f857e8eb9fd7fbdb"
  head "https://github.com/hyperrealm/libconfig.git"

  bottle do
    sha256 "b9b5c4811c278a7ea7e193685a5b352e80121d28defb23715df4b66e98e33af2" => :high_sierra
    sha256 "31ed172343eb35e862fe8e8eb1d4850845ea376b8857a1e44239ba8873e9e4e3" => :sierra
    sha256 "ac4deedc89f0c4712ffde498f1eae572c34a5ef1b804a18a1d087fda0f5b43d9" => :el_capitan
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
