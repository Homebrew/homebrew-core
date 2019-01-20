class Ganv < Formula
  desc "Gtk widget for interactive graph-like environments"
  homepage "https://drobilla.net/software/ganv"
  url "https://download.drobilla.net/ganv-1.4.2.tar.bz2"

  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "glibmm"
  depends_on "gobject-introspection"
  depends_on "graphviz"
  depends_on "gtk-mac-integration"
  depends_on "gtkmm"

  def install
    ENV.cxx11

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "pkg-config", "ganv-1", "--libs", "--cflags"
  end
end
