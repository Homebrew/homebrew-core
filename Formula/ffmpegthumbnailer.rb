class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/releases/download/2.1.2/ffmpegthumbnailer-2.1.2.tar.bz2"
  sha256 "f536035c3f2c2455b3180559e3fb3082db275d9264565271053028221dc6d2cd"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    sha256 "7865ae4c722196f8bb9700d4f36f875832cfd6d53e1adec4711b313e2c2d539d" => :el_capitan
    sha256 "79a11e926a3333c7d310e1b04a3bdc6de539ab0db5bdb9e1ae68eecd0f8491c1" => :yosemite
    sha256 "ff2f37d29fdcee104e219718ba94b53118b85b4b6cc862a55bb3885607957c71" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "ffmpeg"

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    args = std_cmake_args
    args << "-DENABLE_GIO=ON"
    args << "-DENABLE_THUMBNAILER=ON"

    system "cmake", *args
    system "make"
    system "make", "install"
  end

  test do
    f = Formula["ffmpeg"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system *%W[#{f} -loop 1 -i #{png} -c:v libx264 -t 30 -pix_fmt yuv420p v.mp4]
    assert File.exist?("v.mp4"), "Failed to generate source video!"
    system *%W[#{bin}/ffmpegthumbnailer -i v.mp4 -o out.jpg]
    assert File.exist?("out.jpg"), "Failed to create thumbnail!"
  end
end
