class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://github.com/lxi-tools/lxi-tools"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.7.tar.gz"
  sha256 "6196980e82be2d143aa7f52e8e4612866b570cfce225d7d61698d2eeb1bf8a00"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "8abe1db4feed78939aad2fcb5ff3691ef65bb5568d4720c08eefcd7ed764f20c"
    sha256 cellar: :any, arm64_sonoma:  "6e54d6184b33c8505b2d1fcdb9e30941b4dcb11c5af0eeaf6a58bf51f02a05d8"
    sha256 cellar: :any, arm64_ventura: "db91c6caf54ba2cfefe385fa604294ba010cde1e3361914f509e886359c7573b"
    sha256 cellar: :any, sonoma:        "8f59f9f854d0d1c50f59305b9f0895b2d57f3bae5260e57e8aa97f9149cf9cc9"
    sha256 cellar: :any, ventura:       "d9d421a14b487c82d19b18492d5f4149e127ef5061d9197171a38bca907378ce"
    sha256               x86_64_linux:  "26ad09a5de577c6994732332c41db9abd9eead9ff22752fa89286e1faf7b960e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "desktop-file-utils"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "liblxi"
  depends_on "lua"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
    system Formula["desktop-file-utils"].opt_bin/"update-desktop-database", HOMEBREW_PREFIX/"share/applications"
  end

  test do
    assert_match "Error: Missing address", shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
