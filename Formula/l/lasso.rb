class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82570a84ba2012ef78d64bbd37fae7c4d1bc407f84e2d47c635370b3bbcd2116"
    sha256 cellar: :any, arm64_tahoe:       "bc2700ca305e5f524b5cbe6bed25d58e55fdc85c9b9af8af8c13c776eea42a66"
    sha256 cellar: :any, arm64_sequoia:     "542df25969638209ea318cf5f6a4e474fda77e488cfdd23d040ad6646297c3bf"
    sha256 cellar: :any, arm64_linux:       "88dac0feb5a012d78dcf0140aea6a3eadc714121b036fe5f6d868aa3e486b32a"
    sha256 cellar: :any, x86_64_linux:      "eb32729a695afa595ee53cbd00158c8aea5250792cebbc22be9b5c8e1a5d17c1"
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
