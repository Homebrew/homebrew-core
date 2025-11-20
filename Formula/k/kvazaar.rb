class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "ddd0038696631ca5368d8e40efee36d2bbb805854b9b1dda8b12ea9b397ea951"
  license "BSD-3-Clause"
  head "https://github.com/ultravideo/kvazaar.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5c12e32e6a313ca224723c9749e8f3be3e50af939f681bced612633dcf4ca53"
    sha256 cellar: :any,                 arm64_sequoia: "99cc3733edfa5ed0f18da54e9cd91d6f27d8db93efd0f495d93c82209a945e3c"
    sha256 cellar: :any,                 arm64_sonoma:  "a2fd0fe069d60a1ec75b8a460fe1739fb5177adcaad6b0e9e33d68ff57456fc9"
    sha256 cellar: :any,                 sonoma:        "9e53260ba87411d8148b346835daba4c6c5e0cf5dc75875074c5aa129f57f88b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c2a03b189d0cf04ba65181e7bf54f654443cc0289679f56a4f10dc675080597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e018d21e4380d6d65485dd2873dc883e939372c668ad99b1cbf8d1b5ca8e6183"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource "homebrew-videosample" do
      url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
      sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
    end

    # download small sample and try to encode it
    resource("homebrew-videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert_path_exists Pathname.pwd/"lm20.hevc"
    end
  end
end
