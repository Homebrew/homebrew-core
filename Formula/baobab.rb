class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.26/baobab-3.26.1.tar.xz"
  sha256 "7a59ab5945f5d90725231b10d85a1893403f56660b1627c111d2b4eeb1ef787e"

  bottle do
    rebuild 1
    sha256 "8872a4c6700fd712af0f376e2be4cb8daa87629e3c8848a645a6447a3469010c" => :high_sierra
    sha256 "b66a35615da0b1b04463df2e63ffe2a9256cff1bf63a00c8f1e71ab8ac7c5428" => :sierra
    sha256 "675f9a11696972a6cc4e6f918830995fc884d50cfd4a1f032787e19e1bf508bb" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"

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
