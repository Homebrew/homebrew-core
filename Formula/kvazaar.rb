class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  head "https://github.com/ultravideo/kvazaar.git"

  stable do
    url "https://github.com/ultravideo/kvazaar/archive/v1.0.0.tar.gz"
    sha256 "40eb7b4b23897299e99050f0c011e9380cf898b25615dd143f018b278b972a46"

    # Remove for > 1.0.0
    # Upstream commit from 2 Feb 2017 "Fix encoder getting stuck on OS-X"
    # See https://github.com/ultravideo/kvazaar/issues/153
    patch do
      url "https://github.com/ultravideo/kvazaar/commit/d893474.patch"
      sha256 "0d2087dcf535ce01b2cc8afdb138f207e7e2389976fda6167bbb7c22c78c4797"
    end

    # Remove for > 1.0.0
    # Upstream commit from 8 Feb 2017 "Fix crash with sub-LCU frame sizes and WPP"
    # See https://github.com/ultravideo/kvazaar/issues/153
    patch do
      url "https://github.com/ultravideo/kvazaar/commit/b8e3513.patch"
      sha256 "de52ecb665f65be4d364f0070632e660f4bf5a16a47e63064846595b64afe14a"
    end
  end

  bottle do
    cellar :any
    sha256 "45a41530791f514842620ce53d6b03cf3915f396bf50b2fdc7025fd1917fadb4" => :sierra
    sha256 "51cc24538d1978ad0dc4d52056e45a3fcf2960d6d859ec728c4edd44e267dfde" => :el_capitan
    sha256 "165654dedd6d7bb438ea9215789bf97a8fa426b3e7f09b1f010559c680a6b7b6" => :yosemite
    sha256 "ae000ea2d5cb4717dce904aa371813e3603c0b05bf333306948457848e22c272" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh"
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
