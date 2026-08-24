class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  url "https://github.com/gpac/gpac/archive/refs/tags/v26.07.0.tar.gz"
  sha256 "57822c1a74dcb83d76ff1f671e1b4fae2e7614e8194a5adb9f20661e0e9421dd"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e96bcef96cb863772ecc39922b7b5c85a2fa2e31776391547b51120903dae916"
    sha256 cellar: :any, arm64_sequoia: "3a8c864c93a3ca709180e85ea9b44bc068e2f4f67fe251f8f70c6d026eb20c19"
    sha256 cellar: :any, arm64_sonoma:  "6d734eed6998ec195b9c7bd3624c962d267b123a98ec78ba3b87b21cbd449337"
    sha256               sonoma:        "900b5e077c394eb1bf117fa4657a710a3d04937679cec2906a3b03f27c21da22"
    sha256 cellar: :any, arm64_linux:   "3cb38c73094fff869812074cc079df8da73fd6d16ebc26318ede069374229848"
    sha256 cellar: :any, x86_64_linux:  "6988e4e4b5b612961b0834ac9ff7d90d3d742066987a7fd0a166e06816b9ade3"
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
  depends_on "openssl@3"
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
