class Lasso < Formula
  include Language::Python::Virtualenv

  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2782fd1ca39470139eec18542919b21a7f1cfba157413d4b2114ac6050f2655"
    sha256 cellar: :any,                 arm64_sequoia: "73a4b5de8e89c7600198eda7cbe6a6c617645e5a902419856e8c661aad8f9805"
    sha256 cellar: :any,                 arm64_sonoma:  "6b4e27f4dec99b6f3e4fdd7e199fe025913c19bb6cb0bfb9960f4e5e4c8baeac"
    sha256 cellar: :any,                 arm64_ventura: "b5d48e185589b6c5e989efd4334885d05aaeb181fadefc2d679d1296fec110a9"
    sha256 cellar: :any,                 sonoma:        "bdf22529b3f2873ad02c0630beb28cbb6f05656819f7912441fb3324a649cf5e"
    sha256 cellar: :any,                 ventura:       "2d7722abbe72ada2eeb86163ea469ab83bbaba42b4d57183d3c47f08d565fb12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c489df4d15314a1ea8c3589a21dcd9c584e989964d03f26170c9f9def96c6dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d43be485d5889e1ad8fe51b3f9a685bb34e19a1fce924faed46de9f682f5ce"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  resource "six" do
    on_linux do
      url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
      sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
    end
  end

  def install
    ENV["PYTHON"] = if OS.linux?
      venv = virtualenv_create(buildpath/"venv", "python3")
      venv.pip_install resources
      venv.root/"bin/python"
    else
      DevelopmentTools.locate("python3") || DevelopmentTools.locate("python")
    end

    system "./configure", "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
                          "--disable-python",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    C
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["libxml2"].include}/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
