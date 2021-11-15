class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.40.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_2.40.orig.tar.gz"
  sha256 "82e95662946f3d6e1b529eadbd72bed196adfbc41368b2d50493efce6e716320"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0"
  revision 1
  head "https://github.com/FFMS/ffms2.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "320b01b2ff9f7e02f2c9084ff3f5eecfa82ac965be08bb772ab93389e734db87"
    sha256 cellar: :any,                 arm64_big_sur:  "221a3acdb567fd7414a8c8c7a452a878a941962c9c88fb238e6242ae5d7fc1b3"
    sha256 cellar: :any,                 monterey:       "ccab0f325a1aba510fb1f1ae8078243126d43344c1cac035aaf9d1b2829708f6"
    sha256 cellar: :any,                 big_sur:        "d3933ecde477f9ad7156ab174af028a409cf1a9e9def84f775036704a413101e"
    sha256 cellar: :any,                 catalina:       "978c5addaa61cde403d5f5cf51448d6b9512e68c08570385b3ef645e39813d8b"
    sha256 cellar: :any,                 mojave:         "4c9b2aa7932969e43df33c69c559df7bbc3212011e94a073cfb3024e334f7fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d18d8d718e46acabd4fa3a305667cdae70d9e82bc2905d2857f06c600ae049"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
