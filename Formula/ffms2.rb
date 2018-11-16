class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.23.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/f/ffms2/ffms2_2.23.orig.tar.gz"
  sha256 "b09b2aa2b1c6f87f94a0a0dd8284b3c791cbe77f0f3df57af99ddebcd15273ed"
  revision 2

  bottle do
    cellar :any
    sha256 "2fad93e303cdb24e72a4031d39205a27cd868bf4433420b2b5aecc695a1a3a41" => :mojave
    sha256 "50d0d16a2073f107af6f40e5bb4f75be24dcfb494cfe002fe72da672dd8df9a5" => :high_sierra
    sha256 "5306d46430cbe4c97dfc30a600adcdb8c3128cd2bd983fac920ffb82d75816b8" => :sierra
    sha256 "9aa072e39b534a47af137f065235fb2a2c63c0051ebc084bfbb399907f596b28" => :el_capitan
  end

  head do
    url "https://github.com/FFMS/ffms2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    # For Mountain Lion
    ENV.libcxx

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-avresample
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    # download small sample and check that the index was created
    resource("videosample").stage do
      system bin/"ffmsindex", "lm20.avi"
      assert_predicate Pathname.pwd/"lm20.avi.ffindex", :exist?
    end
  end
end
