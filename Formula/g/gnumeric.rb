class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.57.tar.xz"
  sha256 "aff50b1b62340c24fccf453d5fad3e7fb73f4bc4b34f7e34b6c3d2d9af6a1e4f"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256                               arm64_sequoia: "8a7e1965742b9ea886076a57802002fa062ce77435d002015f0919e559ed1351"
    sha256                               arm64_sonoma:  "6a82deed674c951c5c9f9c7938b9a9c2f1a9417fb1c4174bb6d06378c2bec735"
    sha256                               arm64_ventura: "755f8dc344fe237adb34974cf2ad0b14ef86665be16a442f8160b408e32f5f67"
    sha256                               sonoma:        "9898fe1f0c8e15a02ca97a2cb233434a1a74680efe2325d355ae5cc335b5ab1e"
    sha256                               ventura:       "143e39f6cbb0705c3016db957c5d238a45333c1bfe7efccce9dba3b571555d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f3af98641cad01596d6f079d71a16d0bf120a21ec50381890946cf0a2354d6"
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
