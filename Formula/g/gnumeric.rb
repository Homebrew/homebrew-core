class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.59.tar.xz"
  sha256 "cb3750b176d641f9423df721b831658c829557552f8887fedf8a53d907eceb51"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 2

  bottle do
    sha256                               arm64_tahoe:   "9da9cbad74c76bd39d93f36974cdcf4bdbd186dc2af72349cfe1362fec977c49"
    sha256                               arm64_sequoia: "116d894c3ee141e76c24774a0767b8b68d8d003c017954ab39b0bda30f0c6637"
    sha256                               arm64_sonoma:  "af4d0e69a15e935de205cf2926fec9741bcdb116fa1d22dbd9d89eb02d53e8b9"
    sha256                               sonoma:        "5670639d8ec74bb1bb6c654eed3a87aac60663f10a3690fe0a21ae1fbc696355"
    sha256                               arm64_linux:   "769d103e022682ec11f401a0cab91c2569fb12c32fddd68a275cb5463f4ac3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72004151f4322b6360234f29e0ab659c27ed28c69971cdf6f71c5f7f76e873a0"
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
