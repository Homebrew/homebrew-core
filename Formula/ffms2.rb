class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0"
  revision 3
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  stable do
    url "https://github.com/FFMS/ffms2/archive/2.40.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_2.40.orig.tar.gz"
    sha256 "82e95662946f3d6e1b529eadbd72bed196adfbc41368b2d50493efce6e716320"

    # Fix build with FFmpeg 5. Remove patches in the next release.
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
    sha256 cellar: :any,                 arm64_ventura:  "43602ddccd0d7d579ff2b0409dc3f9ed4958367cd406fe18b8a9624717ad8495"
    sha256 cellar: :any,                 arm64_monterey: "6a5f31157cabfd498933f6aaf56b2cbc2b45c3aecec7cbd21664139a9debb10d"
    sha256 cellar: :any,                 arm64_big_sur:  "a6d5f4ef9f9230a782fd2f0557059ad2f27fb5aa68fca54ac7a1de3b92e3c09c"
    sha256 cellar: :any,                 ventura:        "bb354ca6429730cc49f3a38322639fc57d78d8cd7efce7541c5eae86342c9678"
    sha256 cellar: :any,                 monterey:       "447cb287946c8fb459b8d0a8b4040550c342282ecb32528008d9e557445b2e2d"
    sha256 cellar: :any,                 big_sur:        "787a2bc2e060c2d97c7495f56c441075aeb94ed04932be8f606517a14f1a597a"
    sha256 cellar: :any,                 catalina:       "3e8716b0666397f71dcf28a8c08709a185b7a5d6e8e7f02b331a9056dd7ea7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46eef6f13630b2739aca52c4cfd61b390ce70e9c2f659e62efad05bdbc1570b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    # For Mountain Lion
    ENV.libcxx

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
