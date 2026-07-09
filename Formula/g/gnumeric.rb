class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.61.tar.xz"
  sha256 "2ac135d856572713c1a408b76b50a59f2a9769ed21f1213446b5af255df20a12"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "54f533945d5760b0f49419b1424f76a9c7c4bc30733c800ce19794b293c7437a"
    sha256               arm64_sequoia: "d640b0d20c0d95b7bbe8d2404ba854a3912b043d4246198bafe1f98663061ffc"
    sha256               arm64_sonoma:  "48de2745448bf7196568b63c58cfaee2cef1931c63bcf90fc4c7b723e9881f7d"
    sha256               sonoma:        "b9e086fb15b23fa7eb1748926a04f6a18906856e6b000dc45ee9d5f044dade0a"
    sha256               arm64_linux:   "7f50e04e0fb25142406b6694c159ae0f9a4a120e24f4d8ed8ae4e5d638b28689"
    sha256 cellar: :any, x86_64_linux:  "29815bacc39ff55a6e5b7be7c5eb21350055d2330ed7c915457eb7ad9e3d7ebb"
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
