class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/2.2.3.tar.gz"
  sha256 "8c9b9057c6cc8bce9d11701af224c8139c940f734c439a595525e073b09d19b8"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99daec9ab7483eb10f980b1876a2af01a5b20c339225f51af9deb7eee2b50fe0"
    sha256 cellar: :any,                 arm64_sequoia: "4864f88829cb1785b49323ef27cb543847de5f9222568da0ec47b5b8f1ed95d7"
    sha256 cellar: :any,                 arm64_sonoma:  "f45c64ffeea08f32d6fa8bf2895b3dbb16bac6e1351ab7d3b9f165bc7bf1f553"
    sha256 cellar: :any,                 arm64_ventura: "7e8ce3a0c5f1d711f67000d6f0f4c16b9f0c8c6cb637ee46fa36287763c26931"
    sha256 cellar: :any,                 sonoma:        "0da3e60f09e8431204758eee45049da94e9e1d335af0b4d83f46aef733ef5404"
    sha256 cellar: :any,                 ventura:       "2bd1cee99515643680cca8efd800981497ed5ca0376257d500554c6983bd3092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9d395260e50724d95a2b6c69bda115fd494a2a058d73c248b7c24c5b1ed50b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f655ccb6868831e733e478aa253684425fe6d880f86a23284f5ec7040d3299d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg@7" # FFmpeg 8 PR: https://github.com/dirkvdb/ffmpegthumbnailer/pull/240
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_GIO=ON",
                    "-DENABLE_TESTS=OFF",
                    "-DENABLE_THUMBNAILER=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ffmpeg = Formula["ffmpeg@7"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end
