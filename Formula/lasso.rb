class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.6.0.tar.gz"
  sha256 "146bff7a25166467d960003346cbc3291f3f29067e305cb82ebb12354c7d0acf"
  revision 2

  bottle do
    cellar :any
    sha256 "2205d01fc955e79915ec59ba8acfa1221fcac6cd382529fcc08a2db6809e01e8" => :mojave
    sha256 "e65e3b3b6ce40489b6674c51ccd6266d8a8167e6de99eb237e3a5a8a7473e33a" => :high_sierra
    sha256 "de394e2052991b6fe749d8f8e00f7999c84241cfa93cb68791f2e2cb1a68381a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libxmlsec1"
  depends_on "openssl@1.1"

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
