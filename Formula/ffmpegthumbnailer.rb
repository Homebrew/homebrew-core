class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
  sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"
  license "GPL-2.0-or-later"
  revision 8
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "726df608338d6bedd7a01a39251bf3ef7ef05ef898aa768621a26f3910f83b2a"
    sha256 cellar: :any,                 arm64_big_sur:  "fc6ee18ce9bb3e0a244d910273dcfe497fe6ad0a3ddac5db845e70c88efd9494"
    sha256 cellar: :any,                 monterey:       "ef2bdff1a7bb4de0676c920a06bb2e169215a0557f443f25535d1f04f7406269"
    sha256 cellar: :any,                 big_sur:        "84cfd73c163a152b40dadb9fe8829f07049aec62309b194ddaf2c9a5bbd435f2"
    sha256 cellar: :any,                 catalina:       "c5dc4f08d22937f9a66aae08aab1e1e8e98c166407c696953a8b33cb7c5d9767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6970edbfd982c1d4f95c30fe663413441c69c7509742b9adace3c286fce75895"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_GIO=ON",
                    "-DENABLE_THUMBNAILER=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
