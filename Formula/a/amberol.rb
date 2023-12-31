class Amberol < Formula
  desc "Music Player"
  homepage "https://apps.gnome.org/app/io.bassi.Amberol/"
  url "https://gitlab.gnome.org/World/amberol/-/archive/0.10.3/amberol-0.10.3.tar.gz"
  sha256 "52372ec6f5ba066409e8dfc4a62fdb2c57e79f83a809cf295ff0e040eebb233b"
  license "GPL-3.0-or-later"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "rust" => :build
  depends_on "xz" => :build
  depends_on "dbus"
  depends_on "desktop-file-utils"
  depends_on "gstreamer"
  depends_on "gtk4"
  depends_on "libadwaita"

  def install
    mkdir "_builddir" do
      system "meson", "setup", ".", "..", *std_meson_args
      system "meson", "compile"
      system "meson", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test amberol`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
