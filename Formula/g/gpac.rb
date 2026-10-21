class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  url "https://github.com/gpac/gpac/archive/refs/tags/v26.07.0.tar.gz"
  sha256 "57822c1a74dcb83d76ff1f671e1b4fae2e7614e8194a5adb9f20661e0e9421dd"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "290a9890df2edb3a4d8ac1b69fea23a6c4741639b8c55df63647a4bc0b8afd34"
    sha256 cellar: :any, arm64_tahoe:       "7e3b4dcf71025b8175f3b041e4bff0edb21f7645956c61be334335f1bcc9b168"
    sha256 cellar: :any, arm64_sequoia:     "48d5de9aaec41d4b5a3e03bdbba9b6566a06f2b79050a0d34f91a879106e511e"
    sha256 cellar: :any, arm64_linux:       "6a7c33391cb9793f6237c5f1599c38dfffee2407c0d02278b926e3cea29aa462"
    sha256 cellar: :any, x86_64_linux:      "912259a77887539fc39647c402893cc9d3d8816c04cbb63cf210f130a2aeef10"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libnghttp2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "openjpeg"
  depends_on "openssl@4"
  depends_on "sdl2-compat"
  depends_on "theora"
  depends_on "xz"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  # Fix builds with FFmpeg 9, which removed the deprecated `AVCodec` capability
  # arrays in favour of `avcodec_get_supported_config`.
  # Issue ref: https://github.com/gpac/gpac/issues/3850
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/gpac/-/raw/270a935296832d1daba2e459354a654e60f0fa68/ffmpeg-9.patch"
    sha256 "d1867a638ac3dd83df1c11e46467b96cec13b757317af1bbb9003da926fd8fc7"
    type :unofficial
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"MP4Box", "-add", test_fixtures("test.mp3"), testpath/"mp4box.mp4"
    assert_path_exists testpath/"mp4box.mp4"

    system bin/"gpac", "-i", test_fixtures("test.mp3"), "-o", testpath/"gpac.mp4"
    assert_path_exists testpath/"gpac.mp4"

    assert_match "ft_font", shell_output("#{bin}/gpac -h modules")
  end
end
