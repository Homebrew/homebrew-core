class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.3/gtk-vnc-1.3.1.tar.xz"
  sha256 "512763ac4e0559d0158b6682ca5dd1a3bd633f082f5e4349d7158e6b5f80f1ce"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "55b9dfd074f9309861de790098935b1b052d7e129093b9261d723a2b1f6a0720"
    sha256 arm64_monterey: "1b12a1de712b421723febd798573d93def5408c35b5aced4b312f4c474a5e589"
    sha256 arm64_big_sur:  "9214a517b4d49c2dd9d852d0d85c5895df014313aa1c4abfec708d405104c180"
    sha256 ventura:        "1372ae5002ee9f681217c7a6fa867061232eae1b350e2a3120f58aff59882f49"
    sha256 monterey:       "3399cba6a3975203385c2f92515f2633f90b73edd0e5c93e40610535a5ee4e43"
    sha256 big_sur:        "b8ce0008b4897b2b9fcdd9294deee5fd1dfe7525172837d667ae660f84fb5c00"
    sha256 x86_64_linux:   "f444122e06038567859a2f24c680384851cf9fc51e98c2231e53b12ffdb50e82"
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
