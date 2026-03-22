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

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "83712dce18d0595c9f12c0a24ee58c518d944b7ac1d6fa1211dc1c73504cb351"
    sha256 arm64_sequoia: "f7679b80723a22bbd7b1a376f248aac379ec54563fe81834170d18560cf344af"
    sha256 arm64_sonoma:  "2745cda31a2d5808bff9a7a9b4b33396e035a4188d247249bf431e556291dfe9"
    sha256 sonoma:        "812a78cc1831522196e0c032173f0ce36878b10270ac165bd7d9bfad1e00c110"
    sha256 arm64_linux:   "83ecf718551bcb1caab684ab463cb3a3a2db17babf574aa3238fa3fd175d9124"
    sha256 x86_64_linux:  "2eb555c0acfd1a52c26080031a4938a3107a16a5aea2b531b2e034ece167940d"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
    depends_on "zlib-ng-compat"
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
