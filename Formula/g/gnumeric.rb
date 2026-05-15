class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.61.tar.xz"
  sha256 "2ac135d856572713c1a408b76b50a59f2a9769ed21f1213446b5af255df20a12"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256                               arm64_tahoe:   "87ec983634c95f3a84ef0a5dfd4f2d931cf7e079e8a8c517e3c1e4828140c6b6"
    sha256                               arm64_sequoia: "b70ab92ff63874564f70ee766b785b943e4a2e6ec5db93c44f68cce0bec6da7c"
    sha256                               arm64_sonoma:  "41c16d0cf0f9d92ab8281f55c4c290b108c620bc84a36459799db8c0b5795369"
    sha256                               sonoma:        "4ee29f1b229de7caca627d0752ff2a4d7484e4058010ee567e826b2b93138d12"
    sha256                               arm64_linux:   "0e82f4e32957739e9b0c58954ff8a39a188e06b495773f8facde3ee04b513a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa182bbed6dbc997896f45691b6515e4a640265d26a8eeae8343987b7d0cdc69"
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

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
