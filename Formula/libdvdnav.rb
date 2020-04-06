class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.0/libdvdnav-6.1.0.tar.bz2"
  sha256 "f697b15ea9f75e9f36bdf6ec3726308169f154e2b1e99865d0bbe823720cee5b"

  bottle do
    cellar :any
    sha256 "658ef3ec8dcc5a332385fc02ca253923bdd9ac3f528e6ab9f6d58f358e766dbe" => :catalina
    sha256 "7c4441a7ff5417d98f72e9b291988726348cce70d5888198b9064f46586128ee" => :mojave
    sha256 "945b05e00ba0dec00311b3084459e0f64a224b47fbafeabd5c3e2e346c4ce565" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdnav.git"
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
