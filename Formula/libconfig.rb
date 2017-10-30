class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.7.tar.gz"
  sha256 "6f7ce87ecfe11327ec7f9f3a016c5007286b327eee1adf5145ff70238b379304"
  head "https://github.com/hyperrealm/libconfig.git"

  bottle do
    rebuild 1
    sha256 "23e530c1de99bced2f55361347920cb9149b816dcd6e273db90c8211bbbbe025" => :high_sierra
    sha256 "238bf662b61ce2ed2b3e4ef0cf932ab4c9fe784f23d5d82576b79ce552db10b6" => :sierra
    sha256 "2194870d1e0f7dcdc03df3637bfb16c92ddd03f1a65870c0498e28b06308f5bd" => :el_capitan
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
