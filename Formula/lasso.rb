class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "http://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.6.0.tar.gz"
  sha256 "146bff7a25166467d960003346cbc3291f3f29067e305cb82ebb12354c7d0acf"

  bottle do
    cellar :any
    sha256 "5a14339bc65d458ffd1b0024be815cd73b8114dcdb9955ecacb66cf79f4d1589" => :high_sierra
    sha256 "f2e0bc889badb79e430b35c19e8aaf26d23370fb4113c1c1a96d81d0d6296480" => :sierra
    sha256 "b36834a1ad4134e0ea4c20f93ea48eba5cbe27daa8f4f74df10bf279c34e41f5" => :el_capitan
    sha256 "5d088dabb95573f5b018ef9338ac1cdf0263e8a6178bda2f519b2c684df6d1c1" => :yosemite
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
