class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.34/baobab-3.34.0.tar.xz"
  sha256 "46ebd9466da6a68c340653e9095f1e905b6fac79305879a9e644634f7da98607"
  revision 3

  bottle do
    sha256 "3994419a1e326594308a62dc3e051f19c3bd611ad1b6b30b0f2098e2d5d9df6a" => :catalina
    sha256 "b514904b1cbd48c875f9a3de57a376f8349b70cbda60a20de46948948fab7020" => :mojave
    sha256 "8bdbbb883b2ea30b0585a168a69e3a6601bc8663076769f4af1f0d6c311e699f" => :high_sierra
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
