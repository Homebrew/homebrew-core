class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.34/baobab-3.34.0.tar.xz"
  sha256 "46ebd9466da6a68c340653e9095f1e905b6fac79305879a9e644634f7da98607"

  bottle do
    sha256 "720156b89e707645562c7d4bbe6f630dd85a371588a69dca181356d21d445500" => :mojave
    sha256 "754b24a65120fc1aa7d289fc357ed45c7305e802d5d0d71962bd8fde886b3d67" => :high_sierra
    sha256 "881bb64db834d11db421bd419195c4bda0b750094f24cbd4dbdb469684af7d88" => :sierra
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
