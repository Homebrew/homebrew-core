class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "ddf561e294385f07d0bd5a28d0aab9de79b8dbaed29b576f206d58f3df79b508"
  license "GPL-2.0-or-later"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08e319540e8ddc4a09246ef099e1103dc4e8dccb95752448704cabc96d10a886"
    sha256 cellar: :any,                 arm64_sequoia: "e60072f9d2a5d3a697135153f25d75c77da03073bb0125454c9c06deab863165"
    sha256 cellar: :any,                 arm64_sonoma:  "824bbba3645c7d772878b50f0f1c13be27cfb76efbdd208756df8b940e816554"
    sha256 cellar: :any,                 sonoma:        "f1fb9f35f2f829e86f25324b42c4a609433429cc64dfe43d2fcee4ebb099d78e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71eccfa399cddb86492a70bb48cb2c85b7263fa39d640d01a77976a0b8ca8529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2326808fbabc3ae36f25299da82e352d7bae86b629b72de6ca22c4fcbf03d15a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
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
    ffmpeg = Formula["ffmpeg"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end
