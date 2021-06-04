class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/40/baobab-40.0.tar.xz"
  sha256 "a6aeaa2c327a997fe0d5f443ce95b785e2ba6e338fb0a026cb7dc7d7d688d1a7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "27c6143dd90728a116f8a0daff9a5d8c1662b1fc519634e917dfcca7c1ec064a"
    sha256 big_sur:       "d21a3f65fbc547f6aa0cd4754b21a7e6804684d2c7e764d5acb4d51a4be7203c"
    sha256 catalina:      "a7f3874c75b014c3446584a11e40b8747f64bc04e20833c0ffc2fe3e1645700e"
    sha256 mojave:        "7a52794f9036e131a6542cafa535db1981dd6ea2daceea3c5dbbf6121225e36a"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libhandy"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
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
