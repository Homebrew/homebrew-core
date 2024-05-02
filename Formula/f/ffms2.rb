class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0"
  revision 5
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  stable do
    url "https://github.com/FFMS/ffms2/archive/refs/tags/2.40.tar.gz"
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

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72597e1adda2f0302cdc138e81226ba8374739fbee6d25f98e77d33fac48ca7d"
    sha256 cellar: :any,                 arm64_ventura:  "d3cea8104d6ed35a04269791d554fe0e42b38d2eea50191ff8ab51043687e6c5"
    sha256 cellar: :any,                 arm64_monterey: "82a3cc0c378bcc1f00935e368db5570aa566e10237962439d2a85c7c5d6525d8"
    sha256 cellar: :any,                 sonoma:         "f37ff12f719209caa561849a6aedc890accc2dfd877b3dfea7b77e002ea8b769"
    sha256 cellar: :any,                 ventura:        "87ab1c98928a90b2391aaf638cfaec141e21eac099566f418484b6f4f891c192"
    sha256 cellar: :any,                 monterey:       "bdd001b5547e9c5ca7b1ac1ff9cb5635424f48ab6cff3158d5548f6d9b89f064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260be451fa4aba990e99e519329b8190a599e06f84d88731ec10a4f6085a639a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"

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
