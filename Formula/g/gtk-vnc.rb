class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.3/gtk-vnc-1.3.1.tar.xz"
  sha256 "512763ac4e0559d0158b6682ca5dd1a3bd633f082f5e4349d7158e6b5f80f1ce"
  license "LGPL-2.1-or-later"
  revision 1

  # gtk-vnc doesn't use the usual "even-numbered minor is stable" GNOME version
  # scheme, so we have to provide a regex to opt out of the `Gnome` strategy's
  # version filtering (for now).
  livecheck do
    url :stable
    regex(/gtk-vnc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "2d43bed50ae8dec6f17f3fce8c398c44d362741e949df7104147f029aae9f11b"
    sha256 arm64_sonoma:   "1d86f05b499aca8550e57a6ee7da3aa3dbac6c71315a8fb99744e8dc6c00fe58"
    sha256 arm64_ventura:  "bf1f1b44af9394444c670557a75710c82d7b6f748150f80beec54eb30a81840e"
    sha256 arm64_monterey: "48885c5c13f4d2a23eb1d236a8ee89f9be610831ac7f129d610f6e7b984c2b40"
    sha256 sonoma:         "08bc0bff60068971369a5baaea058ba8e01e403a03f33f8f5f4d45d73b3551e0"
    sha256 ventura:        "6c50230eb976ffcdb056931d1a3a4217ebb19e9a7ea23beba16fa274ec358a04"
    sha256 monterey:       "7242716e44c0aa52b9b0a481e445a34eedbcb75cb15f0a8af38374666cc8d06b"
    sha256 x86_64_linux:   "9992fdf41743bef7fb279857b510441e0b95b63082ccaad5690a36776de48089"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
  end

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
    system bin/"gvnccapture", "--help"
  end
end
