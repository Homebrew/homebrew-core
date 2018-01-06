class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.7.2.tar.gz"
  sha256 "f67ac44099916ae260a6c9e290a90809e7d782d96cdd462cac656ebc5b685726"
  head "https://github.com/hyperrealm/libconfig.git"

  bottle do
    sha256 "0f77666e9a1e8bd6290a70df039aa97cec52ac79485de268a589ee46e82f4ce3" => :high_sierra
    sha256 "8370ecedcfd9a2709efcbf822f6dd1497b9d11efe5a109d5ec05b0f7f3e850d4" => :sierra
    sha256 "a7b8640a4f169cf82eb6e9aa79e01b59ed1d2914f373abcd2602241b5a21c518" => :el_capitan
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
