class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.8.0.tar.gz"
  sha256 "ffcbd5851d98586c7e1caf43bad66164211a3b61d12bf860a0598448ff9f2b38"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8943a75c665721e4bdb0a8b0d078cbc466fb15b3f9d51e31af01d62cd795e090"
    sha256 cellar: :any,                 arm64_big_sur:  "30e41c13e7fbfeab7f94bf316a430c986e191c14d92b6166dac9cdcdd88d54e5"
    sha256 cellar: :any,                 monterey:       "0bb3ae919005771283aacb36ab7ba373ac2495401006bd9e561b54e6152a73a6"
    sha256 cellar: :any,                 big_sur:        "1f9f21862e2f5aea3ae37b396ca58b8d09b002e1d44fb961603b78d7e79d7f52"
    sha256 cellar: :any,                 catalina:       "1a5b3eb78b0bb7606fa7a0cdf03c9f75555f9eacb129db91d8f2fc33d59240eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d69063c5d7572e5dd764a461dc4f73277cbe156ea6a540b3597ae7c34931878"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "six" => :build
  depends_on "glib"
  depends_on "libxmlsec1"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

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
    libxml = OS.mac? ? MacOS.sdk_path/"usr/include/libxml2" : Formula["libxml2"].include/"libxml2"
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{libxml}",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
