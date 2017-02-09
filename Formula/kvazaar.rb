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
    sha256 "5dd89059b3af46dc2bb14659e85ef3df0335e1cb4983776618e2a11ebc33bdb5" => :sierra
    sha256 "5bda05263252256cefadb228ec8588f09568d00875a00ef0f12da69ab06868f6" => :el_capitan
    sha256 "ec981006d5607147b9af8a1a1d6e9dca1642b1dd85ac8a528f1c801f82053573" => :yosemite
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
