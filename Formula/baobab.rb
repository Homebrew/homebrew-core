class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.34/baobab-3.34.1.tar.xz"
  sha256 "7f981d4f135e4f80fba3f66e86b0eeedc94a2434649262ff01a5f0cb027b20c5"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "8724ad2149b4e8d51b5de9268a3a7cdd99855736478bac1dcf97b3ea6d741ac6" => :catalina
    sha256 "21588b8f71e80696d785cbbe33284214c38f73b2a72a62f537de4e3393ed2bfa" => :mojave
    sha256 "922b36653952a0c8e4c44678faf7d042a1e89c3b455ac1d3e46a4292606f26d9" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

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
