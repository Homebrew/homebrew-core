class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/41/baobab-41.0.tar.xz"
  sha256 "cad6278d2dcc80c84b57105aa5bb58d8a30ce98d6fabd767519ddb86c857e855"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "99df49e1259144e3b641e6cd6b8b71b30a10cf6d6dec12e2b137914708daf9bc"
    sha256 big_sur:       "9dfe596e51e700f6973aeccdbcd4047000b63994e3e6d8af62913d684edfc68b"
    sha256 catalina:      "d873858d8bf8c7358f9840d280f94f5247a11393dc079ebbb659ada5bc7660f3"
    sha256 mojave:        "46b4cfbbfe550d56996a7275049e53f2e8d653c46c750ec4cd48e618cd1c83e1"
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
