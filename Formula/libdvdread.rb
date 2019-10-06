class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/6.0.1/libdvdread-6.0.1.tar.bz2"
  sha256 "28ce4f0063883ca4d37dfd40a2f6685503d679bca7d88d58e04ee8112382d5bd"

  bottle do
    cellar :any
    sha256 "cffe78e773764ebc2067a03fa875681acad0258c7cda6a6f989b0117853a9462" => :catalina
    sha256 "3919d408e59a7b7b50a22e088d347d78e0e5c1a2cf4c9d557210954a0aba9311" => :mojave
    sha256 "71d7adc722864315fcf72d6011b7932e5a038562585ec92ac1adcd7c22bfbcf2" => :high_sierra
    sha256 "e061208a45c20034ca9ef9a49f6b49881dc178e426bb65134c9b61eb285abc71" => :sierra
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
