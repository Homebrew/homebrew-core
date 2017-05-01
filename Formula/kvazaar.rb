class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/releases/download/v1.1.0/kvazaar-v1.1.0.tar.gz"
  sha256 "81386b25651ad328b2b94c269eb5601096b966724e6c308ecc3096eb37ef33bb"

  bottle do
    cellar :any
    sha256 "5dd89059b3af46dc2bb14659e85ef3df0335e1cb4983776618e2a11ebc33bdb5" => :sierra
    sha256 "5bda05263252256cefadb228ec8588f09568d00875a00ef0f12da69ab06868f6" => :el_capitan
    sha256 "ec981006d5607147b9af8a1a1d6e9dca1642b1dd85ac8a528f1c801f82053573" => :yosemite
  end

  head do
    url "https://github.com/ultravideo/kvazaar.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "yasm" => :build

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # download small sample and try to encode it
    resource("videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert File.exist? "lm20.hevc"
    end
  end
end
