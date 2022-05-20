class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/42/baobab-42.0.tar.xz"
  sha256 "4b1aabe6bab1582b3fea79a2829bce7f2415bb6e5062f25357aeedd5317a50dc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "9da5f3fa95fb0e71417f44a42e0639098af94a7d56637c31114428d4a48bf4aa"
    sha256 arm64_big_sur:  "c28802a119235bce9421c2aa156d6108b988a81be44b646eb295b487d7776331"
    sha256 monterey:       "8a5c2803956caadd4bc09c9ef37533cc8c36ca9726430d5072db312cdf91094f"
    sha256 big_sur:        "ab0ba611653c5b25cbe54f1767f86aef64ff7d6c2f8dc8000c673767bbb416e4"
    sha256 catalina:       "3c7bc920f3a4c416715a1eeabb4492eaccd545da6a416674c9801efa2f8415fd"
    sha256 x86_64_linux:   "ce301f6aecb4c053e066ad25b44adfcd3bfe78952df198946b54ae8699643dfd"
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
