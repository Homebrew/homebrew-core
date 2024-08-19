class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.8.1.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.8.1.tar.gz"
  sha256 "60c35feafe341aec8fed9de4b0a875dc0f5c1674c5f5804ff7190a6c6c53dc01"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "47b1930e189414ca9093acd78a9841adb85eb4a4e9256aed9fcf33fe94193f03"
    sha256 arm64_ventura:  "acfdd36eea88731e1a89f4f8f9d49c648d53464108abf7454811a7aa19e18a79"
    sha256 arm64_monterey: "35b070e0cbbd91fa64604f23544ebc0de53408b9ead1a4f625d5519db6fca571"
    sha256 sonoma:         "c720ac9b41db8b5708faf8ea26d6e86716c96ff02baca0151480cb5ffa4676c6"
    sha256 ventura:        "e7a91dc6b7aed9f5d8ee73c88c3e6e400d2f2f4f25819c1f240be9ef1a3487bc"
    sha256 monterey:       "81e07a712af61832aba5ad3c50a25fa56fbadf3aa995e5806da04224c89a2aaa"
    sha256 x86_64_linux:   "35552c6edb31ec7f2f966cd152ca32cd8f32dac5ea6737dc8c01267542bcaba2"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  # Fix scope of 'name' variable in rep-budget.c
  # upstream bug report, https://bugs.launchpad.net/homebank/+bug/2067543
  # nixpkg patch commit, https://github.com/NixOS/nixpkgs/commit/5b15ea1e00e33223d52c3aabb821de402265b326
  patch :DATA

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--with-ofx", *std_configure_args.reject { |s| s["--disable-debug"] }
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end

__END__
diff --git a/src/rep-budget.c b/src/rep-budget.c
index eb5cce6..61e2e77 100644
--- a/src/rep-budget.c
+++ b/src/rep-budget.c
@@ -255,7 +255,7 @@ gint tmpmode;
 	}
 	else
 	{
-libname:
+libname: ;
 	gchar *name;

 		gtk_tree_model_get(model, iter,
