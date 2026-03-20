class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.3.1/gtk-gnutella-1.3.1.tar.xz"
  sha256 "9631c82b8c975485b9927a8fa48ef10172d1224e7b3b2049462d37ca33d71f08"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "f492432b6563cffe018b22d40bc67ac10df71218191bcb3d01bdb44439c4fd90"
    sha256 arm64_sequoia: "3ddf5be67bae89d47e24e091fe506f7df1c683afa50c0a9f9bfea627294619d0"
    sha256 arm64_sonoma:  "c1eb2f15ccd9aeb50fdf9b9d0f08e1d9c129e6be6b558f80cec2978e312d7bba"
    sha256 sonoma:        "577e742af6e7e062a2b18bfb59d3081bea7d0bcfe316792d48c899547e21f239"
    sha256 arm64_linux:   "ff989c183f80b230b847617fd63810b60acb3eddd3b003510d414fcebbb215a1"
    sha256 x86_64_linux:  "42da940ea4d5b4e15fc07d033f986b119de287944b136cea7f4ff02319214f24"
  end

  depends_on "pkgconf" => :build

  depends_on "at-spi2-core"
  depends_on "dbus"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work-around for build issue with Xcode 15.3: https://sourceforge.net/p/gtk-gnutella/bugs/583/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_r(share/"pixmaps")
    rm_r(share/"applications")
  end

  test do
    system bin/"gtk-gnutella", "--version"
  end
end
