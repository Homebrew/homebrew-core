class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.24/baobab-3.24.0.tar.xz"
  sha256 "5980e96df9f3d1751a969869ec07bc184ae3ad667d5a3eb06cf1297091fdfc3f"

  bottle do
    rebuild 1
    sha256 "47ad8ce652e9ae5fada91d176d0305996da569ba6f3a7e6830ea8cce8209b525" => :sierra
    sha256 "775bcde9520f07382a7267008b744e9451a433f90832c5b2b6a8d1f8b3c72af4" => :el_capitan
    sha256 "c95601529262447892bd3bcf09ccd37e3c1b5692edf97557346b6a2de93563f8" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
