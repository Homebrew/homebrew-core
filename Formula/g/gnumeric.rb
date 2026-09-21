class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.62.tar.xz"
  sha256 "89331121321b9bad72d37af5a6d13a0a636f0fbb0880f0ea1f2cf8b7ab9ae631"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256               arm64_golden_gate: "fa1cddbde5d32c56f9b5b40dfe610a5e6bb43aebba8b493823a2295a7d2a4983"
    sha256               arm64_tahoe:       "d52dd5b83933ebf27018a2dbf28ef48692b1df0be7bb5f091725a64da534191b"
    sha256               arm64_sequoia:     "2541e9e5802d4c9fbef1435cc100807773798b281a5d6c1a9fba688a90554bbe"
    sha256               arm64_linux:       "acd2be380d54b5a0a9b5be434daa1a9c58c24c275e2cafa228777a542a5b9160"
    sha256 cellar: :any, x86_64_linux:      "cd89ec8174d66d7eeaa79a9d3c4b693b12f571ada27f831d314ec42881678395"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
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

  deny_network_access!

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
