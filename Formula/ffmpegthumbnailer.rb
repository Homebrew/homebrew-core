class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/releases/download/2.2.0/ffmpegthumbnailer-2.2.0.tar.bz2"
  sha256 "e5c31299d064968198cd378f7488e52cd5e738fac998eea780bc77d7f32238c2"
  revision 3
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    sha256 "71ecc0e3166dcd1ce16c2b51b5434a7207f85bf681ebb14910c537ba077b6ef5" => :mojave
    sha256 "0096816909396660805320d6e64b9fec9f5281cdb594edb01d32d1f85fb52234" => :high_sierra
    sha256 "9e8fc85ebc068dbed78505d03e8d095cd1acf128a658a896e77233eec613218c" => :sierra
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
