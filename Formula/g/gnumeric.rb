class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.55.tar.xz"
  sha256 "c69a09cd190b622acca476bbc3d4c03d68d7ccf59bba61bf036ce60885f9fb65"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_sonoma:   "5bff6b05940bdccf798dfc3b10213e9032bbc1ed4fe9a4b33661b6aca6e259b1"
    sha256 arm64_ventura:  "488370521c3bff2b234422df1c6468b33dd562c1497ca4cd8cfcf1c88a1a9dde"
    sha256 arm64_monterey: "b1398c8ebef228c9d6bf70ab7412245efd9e239a84c77a71cb1d26bf8906586e"
    sha256 arm64_big_sur:  "3c638fb56a210bb76c33dc932f74c5640317e90b7f5a61b14ed8cbf76a09eb57"
    sha256 sonoma:         "9651e6351cb2764088a65d063d780e86ba5d99db379a25e8965c76ccb13f3c3b"
    sha256 ventura:        "5d5d4ae015519c7fb93b1e49c865e0cc24402b88628028e5d0b5840fdb2b9abe"
    sha256 monterey:       "abf3df42402d276c0275fd20697f0a1d58e9242cab0b85a3a40257624cba83d2"
    sha256 big_sur:        "233706512d8b3812b44d02048c91edd36976ff7a2a4f86706aba72a9d0ba66c4"
    sha256 x86_64_linux:   "1626ab57af930045ffe261f807e1492580cc9d290835ec1c8b16b11d8bd012d8"
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
