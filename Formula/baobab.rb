class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.34/baobab-3.34.0.tar.xz"
  sha256 "46ebd9466da6a68c340653e9095f1e905b6fac79305879a9e644634f7da98607"
  revision 2

  bottle do
    sha256 "26429e535b510d1c75991c097d28190711b42f996d5b67b530278e82d712b1fe" => :catalina
    sha256 "d9cc7ef952c0ac3195c7539b50a6d05550d93a7e155a4f662bd6fd1476c470a6" => :mojave
    sha256 "52c91b6b0ecf10a220005c3c925feb2ba8cdc7412fdec46a18d9e40c59813ab8" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
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
