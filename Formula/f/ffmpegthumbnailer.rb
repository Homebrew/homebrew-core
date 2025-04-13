class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/2.2.3.tar.gz"
  sha256 "8c9b9057c6cc8bce9d11701af224c8139c940f734c439a595525e073b09d19b8"
  license "GPL-2.0-or-later"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5efa6fb1477d7b41d258ca928b653f1418a84dd85970750105f052a2414afbb"
    sha256 cellar: :any,                 arm64_sonoma:  "d8b455e75a511dce2545d1fd82b53106d4dae32674147c3d69117159222a07e6"
    sha256 cellar: :any,                 arm64_ventura: "5c07ad4ce678518a79c0eb0a73931dce18e98a8783f02318e36852ce6eb16026"
    sha256 cellar: :any,                 sonoma:        "5ed8492099d976f753d53fb621a0750e7cc79f178ee5b51fff24dae04a857647"
    sha256 cellar: :any,                 ventura:       "6047a8a051cde041bb98bc126501c49cc4a59f3babfd43b669252996284982cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "913307a17e34537e06ca04844611558d0cfefd974aca35167b7a8168129db7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "764e0cd873315b8893a45a0043c5dc7c42f0d1f94ce35a076d5e60c4adc1a687"
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
    f = Formula["ffmpeg"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system f.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                   "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end
