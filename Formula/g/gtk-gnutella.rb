class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.3/gtk-gnutella-1.2.3.tar.xz"
  sha256 "dd4ba09de6ff7e928c746e6aaeb2fb6b023c7b3de4ad247ce9f0ee9ba0092ef0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:    "efa3ab8458b2523d7f0c25cd36aebf14b0f8f3b86eb81cbe92724272a693fc08"
    sha256 arm64_sequoia:  "3030cb8995e85c76cca701a9e83c61468fd285975bda9141e80201123579c4e9"
    sha256 arm64_sonoma:   "e57c0c018e79c1ba6db7d5bfbf1603602d44e14b51e962f53770e8de3d557447"
    sha256 arm64_ventura:  "508241efd200736106a8cd21165d828864e7c81d3cc7a59926bc128f84c83b61"
    sha256 arm64_monterey: "bc9a686696930b2a69a462eecac488fe117ef1bce25880dcfb8d120efaedc902"
    sha256 sonoma:         "ce5c4299b77ed4a296744c99138baee934ca0811b00a21731489945575639a8f"
    sha256 ventura:        "b4eef4214608d4cab4598555c39b3c9ef7c497724a5c2c06be09be9e62c0df00"
    sha256 monterey:       "1ddfae5d7de803aed743b7fc75bdafebb1fb2c0823784834142c0f7b579ea804"
    sha256 arm64_linux:    "26f18be0623e97f5f964f3b444ebe037c288bcf41dfd10f94e4dfcd4a44db08b"
    sha256 x86_64_linux:   "70a5946bf77166b5076fe6fa1d45b69c6f512260451c96758c4cde02fbb983df"
  end

  depends_on "pkgconf" => :build

  depends_on "at-spi2-core"
  depends_on "dbus"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
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
