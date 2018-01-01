class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.26/baobab-3.26.1.tar.xz"
  sha256 "7a59ab5945f5d90725231b10d85a1893403f56660b1627c111d2b4eeb1ef787e"

  bottle do
    sha256 "79af97969e50a395e46f26764ac1301c604b7eaea79dc55ca6e97d0e80892709" => :high_sierra
    sha256 "9ac8b22b290f7fd9f27d186f9d830179ab8f872fac8a997f29b01b0cf8a14786" => :sierra
    sha256 "ba775ce84312519ee0da57407c63eaa29157de455ecd2cfca9bb9349ad09ba34" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "python" => :build if MacOS.version <= :snow_leopard
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
