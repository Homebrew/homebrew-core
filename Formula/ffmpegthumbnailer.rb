class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
  sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "692c0b3202acf1e7d3bb6e0dc49abfeb9eae91d87f7ace9f52fcce45caf77889"
    sha256 cellar: :any,                 arm64_big_sur:  "044ab71c693e108bcc7734cee4377ee53400e95eedee527618e480d06e0f0caa"
    sha256 cellar: :any,                 monterey:       "c3151551d8b47f7d7314cd08144a22214ef47ca9c079b14dc84a799ce4cd9a12"
    sha256 cellar: :any,                 big_sur:        "a1ea81c204ac623893693f403375053eb8fce33ca9fddd1964630786147cc1e5"
    sha256 cellar: :any,                 catalina:       "0bacb1352eb215908d5217433493d11867ec205f9364dfb33a2b62323f70090a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b35981ab4fc303232a0602adceff292e014f8d6e248d2a60581891436affd1b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "jpeg"
  depends_on "libpng"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

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
    f = Formula["ffmpeg@4"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system f.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                   "-pix_fmt", "yuv420p", "v.mp4"
    assert_predicate testpath/"v.mp4", :exist?, "Failed to generate source video!"
    system "#{bin}/ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?, "Failed to create thumbnail!"
  end
end
