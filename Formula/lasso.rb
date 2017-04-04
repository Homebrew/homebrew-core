class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://www.entrouvert.com/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.5.1.tar.gz"
  sha256 "be105c8d400ddeb798419eafa9522101d0f63dc42b79b7131b6010c4a5fc2058"

  bottle do
    cellar :any
    sha256 "f2e0bc889badb79e430b35c19e8aaf26d23370fb4113c1c1a96d81d0d6296480" => :sierra
    sha256 "b36834a1ad4134e0ea4c20f93ea48eba5cbe27daa8f4f74df10bf279c34e41f5" => :el_capitan
    sha256 "5d088dabb95573f5b018ef9338ac1cdf0263e8a6178bda2f519b2c684df6d1c1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"
  depends_on "glib"
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
    (testpath/"test.c").write <<-EOS.undent
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
