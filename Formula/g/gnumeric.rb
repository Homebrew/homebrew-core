class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.59.tar.xz"
  sha256 "cb3750b176d641f9423df721b831658c829557552f8887fedf8a53d907eceb51"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256                               arm64_sequoia: "e1f8052c8c05397eeb4bf31306d84731f16c37a6cf6285f359633319f823d00a"
    sha256                               arm64_sonoma:  "4121c93b13a0454fda9a4e94832a32a1c40b9f088987e0c15ff540e3b73b4083"
    sha256                               arm64_ventura: "b3db35307a7753e36193530495205e12e2a375745687fd565d0f292002830f35"
    sha256                               sonoma:        "011604f935d00185e04de4dab0593c4cda3869531e7d8da3c7c16f60b5e7adc4"
    sha256                               ventura:       "431655b749b2dc4e9540390d9101df685bd2d4dc844826937e5a91d07c69198e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf651f16b89c62b500b4da5773a75dc96ddab040d055ba13f9a3d697a8e4ea5"
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
