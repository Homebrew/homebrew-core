class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://gitlab.gnome.org/GNOME/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.6/gtk-vnc-1.6.0.tar.xz"
  sha256 "0e1a1023f191a842e994e5d10053bbe0e76d5f5fb9ec2eb525e2f8fdea57347f"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  # gtk-vnc doesn't use the usual "even-numbered minor is stable" GNOME version
  # scheme, so we have to provide a regex to opt out of the `Gnome` strategy's
  # version filtering (for now).
  livecheck do
    url :stable
    regex(/gtk-vnc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "086558051d9d13d59b802355b500173e1590d88bb3c463509b724c3444f09526"
    sha256 arm64_tahoe:       "64d7a9f0644b29467c6e9fb3e51f9c5e92b4a7cf2f37f54ba7d67d48d42ea2f2"
    sha256 arm64_sequoia:     "9b8cd5c44a6f0b1a0ae27922d8c93e365c61a9dedf42070d2d03eca897beccad"
    sha256 arm64_linux:       "2aafe71d59f4eebb008f0bde9eb1fc4394728cd64646a3df0e05aae6f84bb82e"
    sha256 x86_64_linux:      "82b2e88227c1c37784e0437c7f35cfa7674f60cb3f8e4cdcb7334b293fe4de31"
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
