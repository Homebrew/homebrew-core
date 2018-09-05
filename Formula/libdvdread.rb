class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/6.0.0/libdvdread-6.0.0.tar.bz2"
  sha256 "b33b1953b4860545b75f6efc06e01d9849e2ea4f797652263b0b4af6dd10f935"

  bottle do
    cellar :any
    sha256 "d29ea1990e7b73c08d6ccdfbc54ea9df7f81d4e02587eee1ee09e476bdb95f54" => :mojave
    sha256 "2c79785484da4af875f24b0db9a255d5196c3db5a74ad559f5dc402d3ea1cef0" => :high_sierra
    sha256 "f63a8d47a746bf8df3cdb388c30e9758d0eab8c80d2bfb09eafbc55b0892584b" => :sierra
    sha256 "d5e0649763180f7e948327bb87c7362f01086492b19f6cb343fae4b42ea04ce6" => :el_capitan
  end

  head do
    url "https://git.videolan.org/git/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
