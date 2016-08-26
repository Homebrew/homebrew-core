class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/releases/download/2.2.0/ffmpegthumbnailer-2.2.0.tar.bz2"
  sha256 "e5c31299d064968198cd378f7488e52cd5e738fac998eea780bc77d7f32238c2"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    sha256 "f7dd9d286e2854cdaee94767a255f05141093b3ec3f8caf4264ffde081eb7974" => :el_capitan
    sha256 "fd4a9d200943492c268220bfa775ed6bd26f5c116c7ff383c0fe2f5565a6733f" => :yosemite
    sha256 "5c2e7827b8148d3c9009f4dd7e201b23dced73743299257e6fd16ad140faa06d" => :mavericks
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
