class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_5.0.orig.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95cb1629607cc749fbb2539b42d859e18d8324a98fec677c95915bf1059d3398"
    sha256 cellar: :any,                 arm64_ventura:  "379c741a8043b236ee007ea7a135a1c337e92f790c1496d1d9c72c6439ae5db6"
    sha256 cellar: :any,                 arm64_monterey: "8a2b14cdb1755b0e19878ada11e8c13d86235e4acfdbac3c79a5f65422bacc11"
    sha256 cellar: :any,                 sonoma:         "42e9ceb2071f6e3b545540e54137b0706654ec7564fe89778ac0a7178ddb45bf"
    sha256 cellar: :any,                 ventura:        "765b489b7d023cb5518d390e48e5499d115d487a4fbddc7a120be1002279a638"
    sha256 cellar: :any,                 monterey:       "dc2780271ad98a3f7499d056064fc9e95cc4dde8e2bafa61c03c237de73bde9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf354f0c181a7467b964788baf63363a4bdbea743da40fd725965ada086d4b3a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  uses_from_macos "zlib"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
      assert_predicate Pathname.pwd/"lm20.avi.ffindex", :exist?
    end
  end
end
