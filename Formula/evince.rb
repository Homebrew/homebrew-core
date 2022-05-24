class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/42/evince-42.2.tar.xz"
  sha256 "ff7f81f308cf8d4956ed97fb724a7e49448c214beeab998812ef9efbb38df8ae"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "e606b4c6e7c3eba7b8e986ece1e4dc275118c161693e8409bdfdf4bf90a7bf03"
    sha256 arm64_big_sur:  "3e6e5f201c55c97e434fada5c6f1199b8115e8a7e6b2f815389d049175565b6b"
    sha256 monterey:       "8b7f8d8679817712431d56e5c3ea23715aaf043e6954914cf71fa49ccd9fb163"
    sha256 big_sur:        "8f5c1fa77e8a4109cc5be4cb5ec13c56bb89ca2b92cbf497c3eab162e4e00cb8"
    sha256 catalina:       "890ca50140c3cc168d236faf9685f75a1e4dfc5149b26a7396a8001854407cd9"
    sha256 x86_64_linux:   "1f146a9c0d7574449c1d4edc8c047e85a4983151b5b4904df7248768e5fd477f"
  end

  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "python@3.9"

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dps=enabled
      -Dtiff=enabled
      -Dxps=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Ddbus=false
      -Dgspell=enabled
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
