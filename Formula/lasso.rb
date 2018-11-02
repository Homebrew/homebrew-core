class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "http://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.6.0.tar.gz"
  sha256 "146bff7a25166467d960003346cbc3291f3f29067e305cb82ebb12354c7d0acf"

  bottle do
    rebuild 1
    sha256 "31119ff64238c34da8eb2298515d03cdb827ff18b98e390a2d0b175fdd1efc97" => :mojave
    sha256 "17750cf628c0c32d293d94b3089c604c58911f66fb86858b6254489c90b92def" => :high_sierra
    sha256 "0fc96b1acc751d7de14e4f390f3f5c4ef00299493f51594546858d579d503b02" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libxmlsec1"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-python",
                          "--prefix=#{prefix}",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{MacOS.sdk_path}/usr/include/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
