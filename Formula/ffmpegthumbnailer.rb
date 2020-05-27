class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
  sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"
  revision 1
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    cellar :any
    sha256 "8c727d57cc9e1e757b91eb8c9d02944e00314ae7da4f1029083b612270d17da2" => :catalina
    sha256 "51973b67d0c9b1b2f5968d9f6c27c557e2c419c0f9f6567ce1ee15090adec44b" => :mojave
    sha256 "f444bc8ec943d3422d94dace96d253aca34d99e8e4b806c9c52e6bb559bbf574" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"

  def install
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
