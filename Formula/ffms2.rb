class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.40.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_2.40.orig.tar.gz"
  sha256 "82e95662946f3d6e1b529eadbd72bed196adfbc41368b2d50493efce6e716320"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0"
  revision 2
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f1a45dd4f0f5e982e77b21dd054188c6d21cc92c4ff4b74aad393018066b7961"
    sha256 cellar: :any,                 arm64_big_sur:  "4a15ca2c400590fec38ceae34130e55068b921b361e8bddb78515e698dbe1f8e"
    sha256 cellar: :any,                 monterey:       "d347d4e6c60e31b9c34011ce612292163516a9e2ee2d6a7ae6a33202aef8b3f7"
    sha256 cellar: :any,                 big_sur:        "7068a2792f96145b9d506969e6c8be67860a3761dd85626ea1ea4d2b2fbe952d"
    sha256 cellar: :any,                 catalina:       "b6b9aec2667d3563abe27f82fceab498df32315040caccd22efe365c4d1da205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62658f1852d235f4ce47d3911687a9319717e6e34efe8dd4c7bedc98c798a18c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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

    system "./autogen.sh", *args
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
