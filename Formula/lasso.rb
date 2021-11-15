class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.7.0.tar.gz"
  sha256 "9282f2a546ee84b6d3a8236970fea3a47bea51cb247c31a05a374c22eb451d8d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "86f93ce8ecba12aa60b7e5f6078ef6082f5cbf79efd694a60e318c085d7cc8d5"
    sha256 cellar: :any, arm64_big_sur:  "9fa2831bd4c741367805ff5621489c3cc2ea3f19bafc5252817851cf9d5c0bde"
    sha256 cellar: :any, monterey:       "5e230ae1bb87a06e16d9f4c9780a868c90fdbd5efc341990cc23368136610415"
    sha256 cellar: :any, big_sur:        "600c3e0dad28c4dadfd3c8aa880b3b652e6d7cf8d2bdeb22aa17f97eeb8bf43b"
    sha256 cellar: :any, catalina:       "1b5faa0de1a45cb6d4965d17a1f8480716ab5e5af97ed6eeafa65d69a482e4e6"
    sha256 cellar: :any, mojave:         "226e925072fb12e5009690fa8426c68dfad03fa9633464627a33b0991d29a5be"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "six" => :build
  depends_on "glib"
  depends_on "libxmlsec1"
  depends_on "openssl@1.1"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
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
