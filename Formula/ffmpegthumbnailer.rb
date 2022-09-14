class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
  sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"
  license "GPL-2.0-or-later"
  revision 8
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad656e321013d04bc23f49160bb4476411005e989921c8d2f941644ca735ed7a"
    sha256 cellar: :any,                 arm64_big_sur:  "469d3f0045c47ab3018a13edc8b7d2c2491e813cd91cdd471679dbf6432dd03b"
    sha256 cellar: :any,                 monterey:       "84174aba1d68095104767e77b9aedd340a29e624fdce19a2c16c81323eee0596"
    sha256 cellar: :any,                 big_sur:        "fdf853807d5e4785ab8477ff068b83d81b638000fab8db03590768585a809513"
    sha256 cellar: :any,                 catalina:       "60167d109183ec790d0b4fa7a05f205b7a11ee1a98bdc7b789586e87f07449b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4765f0b763be728e75a97f7db6c0cd62c0d61e56cd61de32549beebf8254dd5f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_GIO=ON",
                    "-DENABLE_THUMBNAILER=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    f = Formula["ffmpeg@4"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system f.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                   "-pix_fmt", "yuv420p", "v.mp4"
    assert_predicate testpath/"v.mp4", :exist?, "Failed to generate source video!"
    system "#{bin}/ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?, "Failed to create thumbnail!"
  end
end
