class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.3/gtk-gnutella-1.2.3.tar.xz"
  sha256 "dd4ba09de6ff7e928c746e6aaeb2fb6b023c7b3de4ad247ce9f0ee9ba0092ef0"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dba801f9ab823ee9024246c6a648d1b1308e9dc8892e60f6fe7d8d0e91566cd0"
    sha256 arm64_sequoia: "2d913d410c4b2d51dc4b94308c1528bf55f192a4bc64e200b502b2786bc5421c"
    sha256 arm64_sonoma:  "43ef1c2f87f12e645959dec87b07f544ba85045977a826a3d91365ea9ded90a2"
    sha256 sonoma:        "cfcb1c63b1eca9e9316526656150e508e3195148828959cfb8881b35a9e842aa"
    sha256 arm64_linux:   "00c1c423bb69cf660fe99d7166778f1ad1fb2204355ad5318a9860926251b4d8"
    sha256 x86_64_linux:  "8612a1b19289875510b282dcc3e728a00e3f275dcda53c3efa38cafef17a4b18"
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
