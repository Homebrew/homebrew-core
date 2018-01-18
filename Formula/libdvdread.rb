class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "http://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdread/6.0.0/libdvdread-6.0.0.tar.bz2"
  sha256 "b33b1953b4860545b75f6efc06e01d9849e2ea4f797652263b0b4af6dd10f935"

  bottle do
    cellar :any
    rebuild 1
    sha256 "df09ae7b2e9919423316037c551e7ba4505be5315b6c22137361889c4bde6cea" => :high_sierra
    sha256 "9a6674198c5624c82f7abe163c606f0f372a02a42a49a3f259f1d74d0c1e2f46" => :sierra
    sha256 "9de98e88e99fbcc899a299786575472c93d442b06838f16bb757e09d4ba92593" => :el_capitan
    sha256 "75006f367876e6ccce744d782f1204ea99d73b55a856ce0afaae2c194eac336c" => :yosemite
    sha256 "79b919acd8c54956680272a32b106882f90027ce148e54eb937b367564b51e87" => :mavericks
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
