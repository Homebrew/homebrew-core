class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.23.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/f/ffms2/ffms2_2.23.orig.tar.gz"
  sha256 "b09b2aa2b1c6f87f94a0a0dd8284b3c791cbe77f0f3df57af99ddebcd15273ed"

  bottle do
    cellar :any
    sha256 "44fe8152389302c40f8bae3b61871ec118e33ccdf52fd58d1051882c841a3a75" => :sierra
    sha256 "c82bf5a6b23a8b60edce118b8fffa947226024be2fac1ccbc36881149be8d14a" => :el_capitan
    sha256 "ccc6ffb553c748f94df62088b699245ca8972056cc592bb3abfd353abfffe61e" => :yosemite
  end

  head do
    url "https://github.com/FFMS/ffms2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
      assert File.exist? "lm20.avi.ffindex"
    end
  end
end
