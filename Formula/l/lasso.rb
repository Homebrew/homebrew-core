class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"
  revision 6

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2460b841e99e74b56f148d5498462c6dd292e62f2ec7a936a757a26a3bb9ddad"
    sha256 cellar: :any, arm64_tahoe:       "5c90bdcc116af154ca039840c09f8526036a0ef73ab9991aeeaae2eb2a45b4c6"
    sha256 cellar: :any, arm64_sequoia:     "ef3d34a0280d0175e3cc51611f57927352daa82cac7351b8ff5cece114c2f1d3"
    sha256 cellar: :any, arm64_linux:       "52dfe1e370a346cad5e957f298be6aadf232a0ab4fc7d99ee995902df4586228"
    sha256 cellar: :any, x86_64_linux:      "6cbf1e41b57170765e65e1cf8a224ad29c123ccc50b9e6313946a841a80dd750"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@4"

  uses_from_macos "python" => :build
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    ENV["PYTHON"] = which("python3")

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
                   "-I#{formula_opt_include("glib")}/glib-2.0",
                   "-I#{formula_opt_lib("glib")}/glib-2.0/include",
                   "-I#{formula_opt_include("libxml2")}/libxml2",
                   "-I#{formula_opt_include("libxmlsec1")}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
