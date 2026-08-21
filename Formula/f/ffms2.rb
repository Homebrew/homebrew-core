class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0-or-later"
  revision 5
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb902e7a5250bf15d0f493636c4fcec52880a72d82d37941cd80dac4a2259ec9"
    sha256 cellar: :any, arm64_sequoia: "62a622df2d25b82b159d45dd43e3be53e100179565aabe66b9d2354833a0b1ec"
    sha256 cellar: :any, arm64_sonoma:  "bc7b8351939b487d569e3ee5d6ade29a4a14de2623b5d1fa95e45dd943e1cb3d"
    sha256 cellar: :any, sonoma:        "1e093ed87dee6fac05650182192784231139ead764fa7497169ad265f84523ea"
    sha256 cellar: :any, arm64_linux:   "8c81538df4dc9528d550e10d4b31aefbc354202085d06223340613855e3317aa"
    sha256 cellar: :any, x86_64_linux:  "5ece14fd0c674c74b7f5936c76c87523d7d82f955a9f20cf8fb9635df4abd882"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "vapoursynth" => :test
  depends_on "ffmpeg"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def python3 = "python3.14"

  def install
    system "./autogen.sh", "--enable-avresample", *std_configure_args
    system "make", "install"

    vapoursynth_plugins = prefix/Language::Python.site_packages(python3)/"vapoursynth/plugins"
    vapoursynth_plugins.install_symlink lib/shared_library("libffms2")
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

    # Test VapourSynth support which verifies Python versions are aligned
    cp test_fixtures("test.mp4"), testpath
    system python3, "-c", "from vapoursynth import core; core.ffms2.Source('test.mp4')"
    assert_path_exists "test.mp4.ffindex"
  end
end
