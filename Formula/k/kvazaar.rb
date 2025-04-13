class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "c5a1699d0bd50bc6bdba485b3438a5681a43d7b2c4fd6311a144740bfa59c9cc"
  license "BSD-3-Clause"
  head "https://github.com/ultravideo/kvazaar.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8d9e19a77635ecf9a1c6b496b498b6a6c3e571bae726e440dd14dbf9aa6f15d6"
    sha256 cellar: :any,                 arm64_sonoma:   "1cbad0414bceb5d09a08e111e35cfae189f36a14979126346195b9c2885a08af"
    sha256 cellar: :any,                 arm64_ventura:  "0c93533adcc570792d6c19c12e1aba452de88a7b8145bdf07c17109108c07e9c"
    sha256 cellar: :any,                 arm64_monterey: "b196d9cb2d8f16c21e392b7580a19e5f74c1e485eb793083a2bfafbd65a84b30"
    sha256 cellar: :any,                 sonoma:         "c881324ae98a472927554e4bf70a17a58a1b3379d25001f3a568b2ab1fcb6cab"
    sha256 cellar: :any,                 ventura:        "3ece2ea661d18cb5918f69e7195bd81099410e791cd0dedbcc45804228359262"
    sha256 cellar: :any,                 monterey:       "d76eeeebbdb79194bb39d0d0fe3936b2cef84defc4291a2ce7b39c2605d5ed8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "394c7735ec112aa22c3963fd37f0a106671da91184545c7b3eb6f279f7cf17d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0146faec0f382d38334e44d177ce0c75c5de2b1eb042e00040c4e1cc3a401575"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  resource "homebrew-videosample" do
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
    resource("homebrew-videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert_path_exists Pathname.pwd/"lm20.hevc"
    end
  end
end
