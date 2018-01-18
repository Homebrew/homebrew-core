class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "http://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.0.0/libdvdnav-6.0.0.tar.bz2"
  sha256 "f0a2711b08a021759792f8eb14bb82ff8a3c929bf88c33b64ffcddaa27935618"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1bd89882fa99076707b90813ed49cbe3f6f98d433313d0a96309e04f2d5ded01" => :high_sierra
    sha256 "b0846c330986045065d777e5d61260c36663d8d3e01a82c3c78250e2354391bf" => :sierra
    sha256 "c154d3b9579441836cac120264fcc61212347fdb39c9e52a95d22bb10bd5ec59" => :el_capitan
    sha256 "eba1770d502af4fb840ed14fd26e0da38641b1a4d6f7dbe04388fe57e17cf8e2" => :yosemite
    sha256 "c808f52803ee2b8d9644121d9d5a6016e4974cc91d4be54422d7c46be7276031" => :mavericks
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
