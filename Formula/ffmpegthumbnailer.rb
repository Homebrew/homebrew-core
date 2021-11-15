class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
  sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"
  license "GPL-2.0"
  revision 6
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a160e239d14eddf3962d5043bd6fd873d78cd6a01308ed6e068fdaa6d9c6e134"
    sha256 cellar: :any,                 arm64_big_sur:  "7e775c990d239cfb24df7f366fe665dd7ecfe633f5d1ce3ee8d2ee4828932059"
    sha256 cellar: :any,                 monterey:       "d58a50a806aa382fc9f8dacf7b92cdab7e27ab8e12657c3bbad2c5472d00cc0e"
    sha256 cellar: :any,                 big_sur:        "11826f63657d04c2ee822124e826714ca6221980e836c9011c7e300a99d0586a"
    sha256 cellar: :any,                 catalina:       "7b81abe3568934de5c149afc9d253b505f25336e38f23ff2e4cffdd3f58bbc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab851a97a570c64b1820e6b48519a998d755cab36a13cf981bbce6802a83aa2c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
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
    f = Formula["ffmpeg"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system f.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                   "-pix_fmt", "yuv420p", "v.mp4"
    assert_predicate testpath/"v.mp4", :exist?, "Failed to generate source video!"
    system "#{bin}/ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?, "Failed to create thumbnail!"
  end
end
