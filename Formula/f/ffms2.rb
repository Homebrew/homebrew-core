class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0-or-later"
  revision 6
  compatibility_version 1
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "390bc343cb9bfb518424e86486b2caaf0795bb8e4b6d9259100244b25f10a280"
    sha256 cellar: :any, arm64_tahoe:       "e655531ea369437dc0207603d7a40b5d1402350f753f6da925a7aa02377a314b"
    sha256 cellar: :any, arm64_sequoia:     "b81d18042f0c46ca625e453167aa4e566742e195035a5ead37ecf76b97ab8c2b"
    sha256 cellar: :any, arm64_linux:       "3ec9e963f78602bd3cecb7bf7e16e9ee6062ed0de1536438515f9ff581cb3863"
    sha256 cellar: :any, x86_64_linux:      "c5b3e838cdd5c9e9fadb78d7cc96406268071e198deb3c5dc04e471e3356cd37"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "vapoursynth" => :test
  depends_on "ffmpeg"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-videosample", :test do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh", "--enable-avresample", *std_configure_args
    system "make", "install"

    vapoursynth_plugins = prefix/Language::Python.site_packages(python3)/"vapoursynth/plugins"
    vapoursynth_plugins.install_symlink lib/shared_library("libffms2")
  end

  test do
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
