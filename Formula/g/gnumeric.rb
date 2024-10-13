class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.57.tar.xz"
  sha256 "aff50b1b62340c24fccf453d5fad3e7fb73f4bc4b34f7e34b6c3d2d9af6a1e4f"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256                               arm64_sequoia:  "dc450b2534ce288a9589fc5646898c49faae013c6027b3af43fb75a14d402036"
    sha256                               arm64_sonoma:   "9ac4b6038db349fcb894b3f16b2b5450e8b97e130609e8b509e117346eb3edf6"
    sha256                               arm64_ventura:  "d0cb4f9530d15cd61556bc16915e80d0496805fa3a5555d543543ed918de3ec0"
    sha256                               arm64_monterey: "a94bc870862a5c7d92ea8b1baaf3c7cb84e189b17cb1fdc66130e8e080738f48"
    sha256                               sonoma:         "61fe8907d180ec8d1fbc1e810b8f276566822fb916d582bb1e4264c0f3a6fd2e"
    sha256                               ventura:        "046dd2fbc0294941ae45432b97715fb80d4b5159edc05fd83d256a0b08c91422"
    sha256                               monterey:       "640060260af9ef39b76959b827f81c511351aaf6b70b31a43f958c47a95855f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22083c21842d8e41c7a37d5af2bb683d6fb1fb52347db917785fd02024a6a341"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build

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
    depends_on "perl-xml-parser"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].opt_libexec/"lib/perl5" unless OS.mac?

    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
