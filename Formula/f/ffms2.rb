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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "762d4b37cda59b4d929851bb8a206922fe2b5e59919152dd78f4a53e27082217"
    sha256 cellar: :any,                 arm64_sequoia: "e3982aedb8762c68a69e4f0e8ec2f6bf36f72ef6d8970b0bc2ad6b0c652f394d"
    sha256 cellar: :any,                 arm64_sonoma:  "0ebad5227e698f8a477de1eec61e08f39afd387a08bf6d68812cea68a79f8174"
    sha256 cellar: :any,                 sonoma:        "4bbc6ca72fa21c5ba1ab5cf8cc380ed30c4fce7983890ad55e169b942cb60655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0c0cbf02ecdc775ec98aa0db63dff6bbac02e3c1fbbefecba4eb12d1085098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "122322cb5af8f95bfac1fda7cfe7043b91d4205c940382f17ab463037b1fb43a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
