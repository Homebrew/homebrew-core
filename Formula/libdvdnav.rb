class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.0.1/libdvdnav-6.0.1.tar.bz2"
  sha256 "e566a396f1950017088bfd760395b0565db44234195ada5413366c9d23926733"
  revision 1

  bottle do
    cellar :any
    sha256 "658ef3ec8dcc5a332385fc02ca253923bdd9ac3f528e6ab9f6d58f358e766dbe" => :catalina
    sha256 "7c4441a7ff5417d98f72e9b291988726348cce70d5888198b9064f46586128ee" => :mojave
    sha256 "945b05e00ba0dec00311b3084459e0f64a224b47fbafeabd5c3e2e346c4ce565" => :high_sierra
  end

  head do
    url "https://git.videolan.org/git/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
