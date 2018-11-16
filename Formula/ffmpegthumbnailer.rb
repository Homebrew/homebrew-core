class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/releases/download/2.2.0/ffmpegthumbnailer-2.2.0.tar.bz2"
  sha256 "e5c31299d064968198cd378f7488e52cd5e738fac998eea780bc77d7f32238c2"
  revision 3
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    sha256 "d78fbed2b96b295e4b798ed4384cb5562c6c5b53fc834054c2376ccbc7657e03" => :mojave
    sha256 "b0045a9bca8a11ae6b76bb2970acbaf621e0ebefec62923e98f3a4d351b7ce37" => :high_sierra
    sha256 "5e9499e66c34208325a585175b2c18688e7f5b263a2a9223e000ac3dc6e984a1" => :sierra
    sha256 "6c047fa6a18eee3f245e29e92e5f25bfb975815517f1710662bf82d71b78d3cd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"

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
