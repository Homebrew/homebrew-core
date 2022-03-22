class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.42/file-roller-3.42.0.tar.xz"
  sha256 "1c438e6d53ec10ff4f2eb5b22d7bbf28a7c2a84957ab64a751c1cdf3c52302c7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "793ec9e8756e08d21795dde62ae5a5d1c54e1bd3823d08e8f785616b0c7a0c5b"
    sha256 arm64_big_sur:  "ec8dd1da7d8848a40aa0cf197a6a0853335368531b780801195b23762c1275e6"
    sha256 monterey:       "65365f28461d2ba9bd085134e0f7056ea2957e3737b37164e5c62a3d8dac4947"
    sha256 big_sur:        "c5a9da3650723915180b287312a0518f75cf01e191b3a7c1b6127b44f35de9b1"
    sha256 catalina:       "8394e9a33b4c7ee7b9e2b9a85f188ee6ac88512c36aee2aaf1fa6d31b755f1a9"
    sha256 mojave:         "bf140573b865d85ea497b500735e465963559551d382fc6a7c1a0814d3602853"
    sha256 x86_64_linux:   "69d8649eba38a6c77ae695ae11790f53c09b3942698f9cd900ad5e14b1734aa0"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libhandy"
  depends_on "libmagic"

  def install
    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    mkdir "build" do
      system "meson", *std_meson_args, "-Dpackagekit=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end
