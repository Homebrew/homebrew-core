class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_5.0.orig.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d457c72653fbc70e59fef5f37bf1921e3b282452d4e84194f16edfb3a49d3260"
    sha256 cellar: :any,                 arm64_sequoia: "4dae8616980c06dd68cd85802fe951093470fcb84153db6bf480e5e4d33befec"
    sha256 cellar: :any,                 arm64_sonoma:  "11e888ef33d21dfc94592b867dd2b166334f7ec8e8356cdc87a5d063ef9b4091"
    sha256 cellar: :any,                 sonoma:        "f58fff43b6b8363fa8f82a0aaafc8820c5ee8b2750da42d637798f6accd9f079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b01d6a3f90ead613af15aa9c6c2730150d1a38221431b131c03b4d53285278c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3325cc6b72c476f0a99963dfd702df356d3e0bc2fb76ea4f0d01469b45e2a679"
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
