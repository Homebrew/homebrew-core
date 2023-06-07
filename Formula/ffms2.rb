class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0"
  revision 4
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  stable do
    url "https://github.com/FFMS/ffms2/archive/2.40.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_2.40.orig.tar.gz"
    sha256 "82e95662946f3d6e1b529eadbd72bed196adfbc41368b2d50493efce6e716320"

    # Fix build with FFmpeg 5/6. Remove patches in the next release.
    patch do
      url "https://github.com/FFMS/ffms2/commit/586d87de3f896d0c4ff01b21f572375e11f9c3f1.patch?full_index=1"
      sha256 "cd946d9f30698a5a7e17698c75e74572ecaa677b379dc92d92e4a986243d69c6"
    end
    patch do
      url "https://github.com/FFMS/ffms2/commit/45673149e9a2f5586855ad472e3059084eaa36b1.patch?full_index=1"
      sha256 "33d7af8efd9b44ea6414fc2856ef93aeff733c92dd45e57b859989766f32be66"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "023582cd7706fb178e3673a44f19202e96cb7b743883cd3cf2a622bdc28a910f"
    sha256 cellar: :any,                 arm64_monterey: "208bea2bad3ab0e3421a05fb95f3d09234dacfd3dbd7846f37abf9198c725ffd"
    sha256 cellar: :any,                 arm64_big_sur:  "6b0a6c8555f81efe0d9d60a486fc1e132706c4c85dfa38214ae9f5cb7d9348e6"
    sha256 cellar: :any,                 ventura:        "812acac7fead7e70c367494d0847ae9063196157902047c6b4a6226178073d6a"
    sha256 cellar: :any,                 monterey:       "b43c093dba63116882aa97a66d7574fe892e456bf8d4cf08938cbde965039c10"
    sha256 cellar: :any,                 big_sur:        "8af6d5615773b98e695ddc3987ae14ed89900ea3600b9e0c61a76d02e28fef64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b09a1bb54bde4251dff1f4e4f3dfd7bba9a93023bf1c1387a61240a54d220544"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh", *std_configure_args, "--enable-avresample"
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
