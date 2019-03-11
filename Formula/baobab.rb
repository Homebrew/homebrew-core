class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.32/baobab-3.32.0.tar.xz"
  sha256 "39414ce94045b35768acddf72d341e7d436cd71298994379d9cec50b57d2632c"

  bottle do
    rebuild 1
    sha256 "e8319cfc39f4120159194d06eb9314d10118cce307b3f14cf5eb1b1d19a933fa" => :mojave
    sha256 "5334181b0761c0b329727064cc0af772774a5a25ab047e1bca187f62f0558ca9" => :high_sierra
    sha256 "e256084a6b1a30cd87c04b37cefdef405c63bb1b6720e210138bbcd63f02aaad" => :sierra
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
