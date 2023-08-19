class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.6.0/libxo-1.6.0.tar.gz"
  sha256 "9f2f276d7a5f25ff6fbfc0f38773d854c9356e7f985501627d0c0ee336c19006"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_ventura:  "b9e3fdf6f9bf02d0a13c076f9460cc3ea55a78a1387d9b89d52e40375ea6d664"
    sha256 arm64_monterey: "82180c9986e803236f8caba30c00b2dcdddaebaedfeb93a9c19a35fb959d6199"
    sha256 arm64_big_sur:  "56e3e01d82e65127da77eabfa5c109689c752aa039771ad9ec48b6de9910ddfd"
    sha256 ventura:        "73c60cd82012ce8ef4b2db4df25e3ba117c19731cdb844eb53e19df05410b54e"
    sha256 monterey:       "8621ad5d4d88b8313bf012dffba7a9f5c500f0c2f3489aa7fc1726d470e0ff9a"
    sha256 big_sur:        "4fcbf10d05037ee979e9b58ff784cf98528311a686bb4a5325701cd3fc90f784"
    sha256 catalina:       "b77f42736665614730b6f1dfb0645c73a137451435914f5583148e67e265ec1b"
    sha256 mojave:         "f33fe82b6bbdca65f2407dd57380ad0f7f420704a228b0c8344fd49c975115d5"
    sha256 x86_64_linux:   "e4c71798bb2791b2d15a83bd4feb19b9a255bccd94ea14e86d9620871f1aa289"
  end

  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
