class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.30/baobab-3.30.0.tar.xz"
  sha256 "5e4dd06f241eb32f00850efa1a4541cee088de480be2b52d788143187410a74f"

  bottle do
    sha256 "b63fcc8dd3de87dc5ccb37b51a60038eb481f457ef93af3418600b0cbcf600f6" => :mojave
    sha256 "11f6b1bc93bc07d3d029437fca774875c253d0979b689e0e3515da2cd7f62faa" => :high_sierra
    sha256 "2ae6e39ef772e7a43fd04a58c65576b2fd828398f05138656ff48475a9f92626" => :sierra
    sha256 "fac932ecf76732c1284ab91d1da849a514e5b818a684de9b2d4b792cfc6d9a37" => :el_capitan
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
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
