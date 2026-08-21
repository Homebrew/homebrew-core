class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.7.tar.xz"
  sha256 "67cada96a2409c859f378e82fbe868b0e9c00a69e6b7b885d542c64ea2a1297d"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9a76432dbf3de2b5f978893f3bfab338e71b100b81ef0cef68a0d51e509851f5"
    sha256 arm64_sequoia: "7531ab1b2228e2df76eec7f3de2ae197772801a52c1df9daf66102e246f6a521"
    sha256 arm64_sonoma:  "45933a7e7fb0a10406e8229d3457caa327d3373c3750bbac0e5ede094f91584d"
    sha256 sonoma:        "607c23912d7aef061787efc23d8358c6affbdc5c72265d2c1045530d778e8435"
    sha256 arm64_linux:   "3eadf2c56bffc406f031216e18a65eff6fc20d3a34c2c03aefa42e8a4c1bfcaa"
    sha256 x86_64_linux:  "62ae864f882eee7f9ddafd770ad20762db0d5638982747e67722a341504be546"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dpackagekit=false", "-Duse_native_appchooser=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
    update_desktop_database
  end

  test do
    pids = []
    if OS.linux?
      IO.pipe do |read_io, write_io|
        pids << spawn(Formula["xorg-server"].bin/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
      end
    end
    assert_match "Create and modify an archive", shell_output("#{bin}/file-roller --help")
  ensure
    pids.reverse_each do |pid|
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
