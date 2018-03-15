class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.28/baobab-3.28.0.tar.xz"
  sha256 "530bb269e19d1f9f562fab90377eda8ce3c3efd521e4d569f7c40e56fa3e5d63"

  bottle do
    cellar :any
    sha256 "941b9ab6b3cf479355a678115d0a2e8e771e76815341402dc457439715e76a09" => :high_sierra
    sha256 "1526e3b5330de4afad90337aa055968a5771c1d4888d8709b4b96a8757688dfa" => :sierra
    sha256 "ca01848bb1e6f29393816c6fe44380d685dbeae673ff7896897172ecb027519c" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build if MacOS.version <= :snow_leopard
  depends_on "itstool" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"

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
