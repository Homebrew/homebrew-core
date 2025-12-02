class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.59.tar.xz"
  sha256 "cb3750b176d641f9423df721b831658c829557552f8887fedf8a53d907eceb51"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "a1cd006c66673bf6024dc8875650e9a0bca3df72598a54597abb9850a4a6ac38"
    sha256                               arm64_sequoia: "738667b4ef40511bb7c60a207fe287387d600b402261572c6f0ba0c4045173da"
    sha256                               arm64_sonoma:  "738f8a1b06bcc217a6c30ac1b6b51704494aedccc21d8fce16553a2c79b2dc0e"
    sha256                               sonoma:        "fce6853730f422fc1b91019c0ece171bb9c27c3babad912aa892739e26bb67ae"
    sha256                               arm64_linux:   "b4a34fc1194cba94d5391cd787e44d13f7ddc4e51f558ec63685ad5b71a537ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab553070aca5871ab0c5365caa3a51b28514e8b5cc5afe498e8983f359ba061"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "goffice"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "bison" => :build
  uses_from_macos "python" => :build
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-schemas-compile",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
