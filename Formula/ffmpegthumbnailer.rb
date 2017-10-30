class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/releases/download/2.2.0/ffmpegthumbnailer-2.2.0.tar.bz2"
  sha256 "e5c31299d064968198cd378f7488e52cd5e738fac998eea780bc77d7f32238c2"
  revision 1
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    sha256 "09715472732033ae65a2d26a3526bc5de60fcf44ad843349a9a57ba885845f86" => :high_sierra
    sha256 "b0085442d2ba5a93c44b51870da1e5719459712366914883303bc4de2c601e3f" => :sierra
    sha256 "84ad2c8ac398ced2d71cc0e2963e2eaf70c842ff22b4207dd4546ba3f2ff03b2" => :el_capitan
    sha256 "be4a2d019541ca0a1d61b2eec0ed98b389c17a1d990c76d882c51590f8b32e10" => :yosemite
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
    system f.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                   "-pix_fmt", "yuv420p", "v.mp4"
    assert_predicate testpath/"v.mp4", :exist?, "Failed to generate source video!"
    system "#{bin}/ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?, "Failed to create thumbnail!"
  end
end
