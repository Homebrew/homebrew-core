class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_5.0.orig.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4285d9a074aa6adcc2e730826d000cbeb436d9d8bdb4f3a97842aec6044a6ab9"
    sha256 cellar: :any,                 arm64_sequoia: "6c3ddf23bef180ecf0857ade1201c7b1be2d0365f522139d0435ca0614fb9962"
    sha256 cellar: :any,                 arm64_sonoma:  "fbe96279b730758d03155384f195087776ef5899dbac5a1af12d19b77185494c"
    sha256 cellar: :any,                 arm64_ventura: "c198b047753f0485fab0eb7ffb9a7330c9222dc8e216842843f68c9c840b161b"
    sha256 cellar: :any,                 sonoma:        "615383651f78749b3156ef5ed50c88358a84c147c5bf03633f344f9278f479d5"
    sha256 cellar: :any,                 ventura:       "22cf1f6df4187feb8230aaf3a872490867b70877146b328a931610a1a283a0e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b95e619235ff30a48caebe4853bc67adb485f38221aa12ffe68fdac2175bae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552d905d96b635d3fb0814e25e70d8f7f58438dc02f8d3321f576c697861af32"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  uses_from_macos "zlib"

  def install
    system "./autogen.sh", "--enable-avresample", *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-videosample" do
      url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
      sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
    end

    # download small sample and check that the index was created
    resource("homebrew-videosample").stage do
      system bin/"ffmsindex", "lm20.avi"
      assert_path_exists Pathname.pwd/"lm20.avi.ffindex"
    end
  end
end
