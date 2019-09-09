class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.6.0.tar.gz"
  sha256 "146bff7a25166467d960003346cbc3291f3f29067e305cb82ebb12354c7d0acf"
  revision 2

  bottle do
    cellar :any
    sha256 "977cc96a183d5c6f28c43bcae666a2d4eccb58fd3c2efa1a4698db044f24d876" => :mojave
    sha256 "5d5ad0e555f97aad53bd57ba9ee6c737ae7d7b8ecf640247b5c03a77970c1b30" => :high_sierra
    sha256 "c19b194e42fd805269e2bda37cdd0c775c85edd3f9fada69d4fd04e4f0df8249" => :sierra
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
