class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  url "https://github.com/gpac/gpac/archive/refs/tags/v26.02.0.tar.gz"
  sha256 "7a265e1cd58b317d8c9175816a54e0ab14199c21d81eb779047d7088fca52ae4"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b2d9c99d0d9bc24cd5c392091cb890363af39d9214ee1a2c35422208f06bff2c"
    sha256 cellar: :any,                 arm64_sequoia: "be8bb6b0bbbf25456bbd19a39cbca7110e1b49e6bd6dba5eb3e12d9c0e8b1329"
    sha256 cellar: :any,                 arm64_sonoma:  "182ced8e20d0530398046fe48a6b0a5dbdf816a271cadda5d612b8fda236a70c"
    sha256                               sonoma:        "f31f73e8e8c7a7aec8b554b7a860b9e49081d0bc45299083e86316ded86be2f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7ad558c0a70fcf23b5fa5d5e30adfeccd1776c3d96306a2e2e9e3b55ffa4232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2cd87687f784c99df64a1580d282cf9b93c0922f3f4fe1457ba11c0ffc308e"
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
  depends_on "sdl2"
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
