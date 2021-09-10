class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
  sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"
  license "GPL-2.0"
  revision 5
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "0fcbba2353da43ce4c08e4b69d8c43143d8cf3813d240957a4fa783fe85c654c"
    sha256 cellar: :any,                 big_sur:       "0bca865df4298da35227da4090554bc0ee787f05cb6ef5a823d023346e5b48c8"
    sha256 cellar: :any,                 catalina:      "dd032464ff83d935e388a997365f6f0131a70e080c7f4da682a1e6220e60c127"
    sha256 cellar: :any,                 mojave:        "ebdda9295e17e1ca9c7acc0cc392ab995fbf2a3bcbe0ca6eee0a3ced49a4eb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71bee7c064ce6d4838f05ddf09709e8191d5f3fd449f2d735ced5dc5acf85f9"
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
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
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
