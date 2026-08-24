class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "ddf561e294385f07d0bd5a28d0aab9de79b8dbaed29b576f206d58f3df79b508"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cb6ba4c461d7b50c245d0faaa92cfbcc50a13ccbe31af2785e2285b2f4ba205b"
    sha256 cellar: :any, arm64_sequoia: "2e9f60f486c47198c7cfe07820aa9f896b259b96a9d2d5bfc7cc1dbf5b1d838e"
    sha256 cellar: :any, arm64_sonoma:  "82e120225c51dd11a413f57e5f6feafe7ad74b18825857f7d3e611d09551ea37"
    sha256 cellar: :any, sonoma:        "32770bb980cfc478b04900b636b0cac99081e0e9f002dc58ea0f5159f86f10a1"
    sha256 cellar: :any, arm64_linux:   "ac6acefd2b6f54d28054ed7b4cea3233bad690a9fa597183cc730128f5579cc6"
    sha256 cellar: :any, x86_64_linux:  "026f03dc86643617dfa9b7fe068bba4447da0c7e567e0b3e5f318bb0ae79cf2b"
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
    ffmpeg = formula_opt_bin("ffmpeg")/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end
