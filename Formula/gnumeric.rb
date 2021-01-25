class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.48.tar.xz"
  sha256 "57cce33a41d34db81292e9eebae8b5046f30e5d919d848256fbb75bfc132a590"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  livecheck do
    url :stable
  end

  bottle do
    sha256 "c744003a24dd677bedcc09d1f9064a553da3e2539bfbe14173bf6110fb231419" => :big_sur
    sha256 "7d95883c243750094676ada23339c1f39d6b1472b8fcecf87d0793df8c30499b" => :arm64_big_sur
    sha256 "d9edd4ae0d044bfe837cc94adfb5f2cc812ae5706b0e7f8a96a0c7b2f9dae63b" => :catalina
    sha256 "43780a97ecfad5fc206241cebbb2d3f16ced32b36a2f095ea047ab6c27dee1c0" => :mojave
    sha256 "67df679b5fe937f17c339812cf1e06aa7b5d5971f6ebfc5c6772b59952745fb7" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "goffice"
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "rarian"

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
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
