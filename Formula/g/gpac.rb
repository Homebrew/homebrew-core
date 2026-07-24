class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  url "https://github.com/gpac/gpac/archive/refs/tags/v26.07.0.tar.gz"
  sha256 "57822c1a74dcb83d76ff1f671e1b4fae2e7614e8194a5adb9f20661e0e9421dd"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "132c3b88f84e155331f9304e0c8a39f2698ff56f9aef01c5981462d7b317b501"
    sha256 cellar: :any, arm64_sequoia: "14d7442544e7a5298f7f17a3595c6565dc7b195cb9d5543e98678d8625ae60bb"
    sha256 cellar: :any, arm64_sonoma:  "98ddef7b897bf3577931c899364ed6547a6d397f6444b62f5aafe80c12927762"
    sha256               sonoma:        "ea10be1e66ee9d7423367b0714e9bb089fb67553aee79cd3d71b8ea3321a8caf"
    sha256 cellar: :any, arm64_linux:   "409aa8f685a6f2f2fc093328f0cea6bcf8f84f6e471246c5dea125b33e6d0181"
    sha256 cellar: :any, x86_64_linux:  "937b4d265d6c4c1b81af3222e87241fb34c216de1bfcd55ba235abf649da4da2"
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
