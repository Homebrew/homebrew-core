class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.3/gtk-vnc-1.3.1.tar.xz"
  sha256 "512763ac4e0559d0158b6682ca5dd1a3bd633f082f5e4349d7158e6b5f80f1ce"
  license "LGPL-2.1-or-later"

  # gtk-vnc doesn't use the usual "even-numbered minor is stable" GNOME version
  # scheme, so we have to provide a regex to opt out of the `Gnome` strategy's
  # version filtering (for now).
  livecheck do
    url :stable
    regex(/gtk-vnc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "74998a793c0d7fd96b2a9d4a7ed4b0da1a4d84dce9c2f3aac187fb1430f43423"
    sha256 arm64_monterey: "2109dd9faa3e24eb8d2bab51a3e00cfde6f660bd690912326c0185d61b9b684b"
    sha256 arm64_big_sur:  "45af9d03738555dea42232249d0b44d115efa45e45f7e3e304a156ca7101c92d"
    sha256 ventura:        "0280b7af865b61bba28e5f921b7a3905be00621f831e51bdd4291c300bc4fa72"
    sha256 monterey:       "9dd26957dbc1e2481560b641e34d363df11638713cc3e5872ac978f44e658b59"
    sha256 big_sur:        "002f65ea23b94e3307cf9363670d4de923643cde75334294ce9df880dde01168"
    sha256 x86_64_linux:   "4c70374f53d695c50ba007b971f9ea8c3b88136497f2b344e332107ba7807696"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"

  # coroutine: avoid ucontext impl on macOS M1 hardware. Remove in the next release
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk-vnc/-/commit/40c59c557ecf7d22d307b8cf890ce08b0376ca5a.diff"
    sha256 "795f35a50bb4a1976d05b961a708415246a2c3f1164c1f9d4e7931996af9f706"
  end

  def install
    system "meson", "setup", "build", "-Dwith-vala=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/gvnccapture", "--help"
  end
end
