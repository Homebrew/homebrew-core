class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/43/baobab-43.0.tar.xz"
  sha256 "52c6864118f5697f5a5736882dcda27db22e7220bc492838deecc699246cdb26"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "36e7a78b2ac54de9c2a941eeae4699221a255b00700368391fe899890cee0b99"
    sha256 arm64_big_sur:  "5743961c7cb063883844064fad670e28b30a0659b05e3c6359457b48b0279542"
    sha256 monterey:       "8602055a45c12aac7ca949c24d244ad8eb823ba9728849eb19916e7b47a2bed7"
    sha256 big_sur:        "87a993cb66ebb1b1b3e4175bd0ed78d09fbebc3468d6872b2f207c11dc9ba6e5"
    sha256 catalina:       "58ba5831f86cce5d2eeaff71254000aa10ed5cb249553270f50d8956e91c0760"
    sha256 x86_64_linux:   "a8e1d5e8a4bd3bd5ab45d1d2378de419695d4da58e111a3d64113f9d5e7da30b"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"

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
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
