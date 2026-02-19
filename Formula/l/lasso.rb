class Lasso < Formula
  include Language::Python::Virtualenv

  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4c4370dad3e210054a0f2044fa45ba21cba1eb9069c93566f346085c6090dba4"
    sha256 cellar: :any,                 arm64_sequoia: "70828b4406548805b41ef937003e4f834cb374d5b9130bb98caabdc9002271d1"
    sha256 cellar: :any,                 arm64_sonoma:  "7b6a1baa8665772f7b190897f39a202aa4a1d23169b76a9714192654a8b2fdc9"
    sha256 cellar: :any,                 sonoma:        "d357adc4f1e1df85e9023df25fd34dbbe5beac77619d62d5ed6a265c0fda5bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dec9909dba0ebad064501a11a1a52966f41ac9855b7ab4c6e46854ee2a39857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e09b8efe054109d88cf8712058d974bfdb361e6226fe4a2b7c684fbf5d06732"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
