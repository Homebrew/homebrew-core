class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.45.tar.xz"
  sha256 "3098ada0a24effbde52b0074968a8dc03b7cf1c522e9e1b1186f48bb67a00d31"
  revision 2

  bottle do
    sha256 "0ccbc934389445c103643232c5e00e8a9261b81833dbf6d46a3017f8e1827563" => :mojave
    sha256 "fde4d00e34ec7ce8b026950314fc2c879a0317eb8ad482600da018965adc113b" => :high_sierra
    sha256 "b6c7861f5c07afda4641be0b4f09b2cc7cf1b00596b548a94d997c9d1aebede6" => :sierra
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
