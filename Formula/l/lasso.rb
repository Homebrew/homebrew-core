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
    sha256 cellar: :any,                 arm64_tahoe:   "ad3a5f5b9f31fba244ec16bb7636e9d85cf7e402e0a069098b1c492520de4c24"
    sha256 cellar: :any,                 arm64_sequoia: "15541fa9354880fd12b971c2f48e6b5ddeac2f3fb30499108ffa80f4209d7061"
    sha256 cellar: :any,                 arm64_sonoma:  "63d55bf24b1afbc9df4fed1654454f3f90416db3607bcdd1cf152285cc56e154"
    sha256 cellar: :any,                 sonoma:        "eb58c9a5c4fb20ef759953793410c076045d28b0d334eabd123e6bc7fc146b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cca48a0072c49ad5457722cf05b7745c2966eb3d7c9da4b8791d7253cee68224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a9be9b9236464cbc47fdcdb35e077166da965b90bb3b9ccf0f1723dc1394f5"
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
