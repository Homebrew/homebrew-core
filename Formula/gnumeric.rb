class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.54.tar.xz"
  sha256 "46904062fd1c4a4c93596d26bf67932cd72fc0f8d2c5a67c17918527fee82b74"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_ventura:  "36f1062f245e2b7a67a070c344708657eb9372a46802e6cace9a32dcebab36f2"
    sha256 arm64_monterey: "1b03d107808a7075aa009539a00a443ee565d0ad6232b875dc2eee50b3e89b87"
    sha256 arm64_big_sur:  "f94f87d88a5696ea7f8dde28ec73f8aefc54a4ca756fddae92560227fd086480"
    sha256 ventura:        "010d7a007b769e610634caf8765630acee7f4c8adaddc72d720c5f46c51469aa"
    sha256 monterey:       "de0d37822580978070e68446da6b641e782a986213532ca353876ded443618f0"
    sha256 big_sur:        "ffeafebd4bfd50d63ecae271eb9a81b318ad28e72417941df1a904c0997b850d"
    sha256 x86_64_linux:   "55b58532a33bb596e56550979a92a6ce5b6631adabf75e0bc68ca354d4f0befa"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "goffice"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "bison" => :build
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].opt_libexec/"lib/perl5" unless OS.mac?

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
