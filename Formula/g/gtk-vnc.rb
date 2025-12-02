class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://gitlab.gnome.org/GNOME/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.5/gtk-vnc-1.5.0.tar.xz"
  sha256 "c0beb4747528ad931da43acc567c6a0190f7fc624465571ed9ccece02c34dd23"
  license "LGPL-2.1-or-later"

  # gtk-vnc doesn't use the usual "even-numbered minor is stable" GNOME version
  # scheme, so we have to provide a regex to opt out of the `Gnome` strategy's
  # version filtering (for now).
  livecheck do
    url :stable
    regex(/gtk-vnc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "dcf9fa16440c56204a952f4b7220d9de9df68ad1144e1b9bde077b395360b1b2"
    sha256 arm64_sequoia: "fcad7b12178c5357a8f917117a61c27b626a5adb7808a01eb87c2c68706734c5"
    sha256 arm64_sonoma:  "25240b02f2fb63bd13b44cc1e368a5fd67fc9e5cd607648de5382e3e6ddb531a"
    sha256 arm64_ventura: "69e94775e32d33f8163d56fd7c07e82dc420a20243a9a43ae1789e6fc85060b1"
    sha256 sonoma:        "0d033e153eda743deb33774cce0ee4c7bc62adac58d207791938c5137b296bb5"
    sha256 ventura:       "fcc58bb4a4cf61e92eae7caece5eb1b6e0cba0810a88e27e9c8a3acdbd38d11b"
    sha256 arm64_linux:   "f028be663ad772594ce686693d21b3a9db365b9e794ddcb51ef13c8c760d2f99"
    sha256 x86_64_linux:  "24f2a0271895b80c2afacd6b00030879f0d04869b506c773e7688a5c16a12d32"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gmp"
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

  def install
    system "meson", "setup", "build", "-Dwith-vala=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gvnccapture", "--help"
  end
end
