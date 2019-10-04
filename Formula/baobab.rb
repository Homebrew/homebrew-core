class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.34/baobab-3.34.0.tar.xz"
  sha256 "46ebd9466da6a68c340653e9095f1e905b6fac79305879a9e644634f7da98607"
  revision 1

  bottle do
    sha256 "5d067135c6485d32ab4bf69cf70471e2f3e97b7ebe085ca530437bcdaad6e646" => :mojave
    sha256 "ecf65805b45f5e0b7bc1f88248544c1bec9fa97809af03d7f04756d2e4882f3f" => :high_sierra
    sha256 "c2cc7e5bc165be0e0bf96ec9e63deefc204a75ce345a3f8b723577647f35dfec" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
