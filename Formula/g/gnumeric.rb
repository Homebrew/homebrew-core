class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.61.tar.xz"
  sha256 "2ac135d856572713c1a408b76b50a59f2a9769ed21f1213446b5af255df20a12"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256               arm64_tahoe:   "185a10ff6b71eddff3a7ef066fa3839888313baff6c52fb42c24a1fa3b3715a1"
    sha256               arm64_sequoia: "e1eba1be100c19271bd98cfd5db380b7505ede9e3342eac2fe0aba2474837cac"
    sha256               arm64_sonoma:  "a3fec678565a90976b37a461ae3d23cef37440c779d1ef3f1483739e625b1ea8"
    sha256               sonoma:        "dd54c441ba904ababfb55f439a5aee6847cd3e439441f2baa5649d83908cc725"
    sha256               arm64_linux:   "9611234aeac06085b44c798ebe41887e3bb348981bc8b25ea68e680680b31ac2"
    sha256 cellar: :any, x86_64_linux:  "2cd14049194a54b15501d4ef96c54e87fff5306df243f01074fc84068e3931cd"
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

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "zlib-ng-compat"
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

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
