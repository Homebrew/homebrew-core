class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://gitlab.gnome.org/GNOME/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.4/gtk-vnc-1.4.0.tar.xz"
  sha256 "1be64c4e4760c52b3ec33067290d1efa40ad4cecab6c673813804e3c559d9683"
  license "LGPL-2.1-or-later"

  # gtk-vnc doesn't use the usual "even-numbered minor is stable" GNOME version
  # scheme, so we have to provide a regex to opt out of the `Gnome` strategy's
  # version filtering (for now).
  livecheck do
    url :stable
    regex(/gtk-vnc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e4fbfc19655d663d62ac42d2fea67cd8920872f2e7062d04d04db9e640e84f55"
    sha256 arm64_sonoma:  "4c9533a7b17df72d46ca4ab708d7fb819cc785d84d122bcca4c5975be6bc292a"
    sha256 arm64_ventura: "3004e00b5f09d325aea98dc419e455e0180ce3c4c2f174194a469cf2b61cbe70"
    sha256 sonoma:        "cc38da956437c5ded9cb307deea89853870637f83323b94b11be1c455229dc3f"
    sha256 ventura:       "90a6efce4d4be08febcdc180184396fe0f091d299e0f3e3d758424137671e414"
    sha256 x86_64_linux:  "8588d8654acbd5f147f4541d4df783a3fa8d6bd5f737bdba62f74fd448985c96"
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
