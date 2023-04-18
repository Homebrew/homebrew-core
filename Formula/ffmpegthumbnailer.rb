class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  license "GPL-2.0-or-later"
  revision 9
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  stable do
    url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
    sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"

    # Backport support for FFmpeg 5. Remove in the next release
    patch do
      url "https://github.com/dirkvdb/ffmpegthumbnailer/commit/372cd422e57a9a3531eb9a30559d665caecff1ba.patch?full_index=1"
      sha256 "88aecad1b3ba9d564b365a6fa19bf56d14c43d0185de7aefa2e75901669269b9"
    end
    patch do
      url "https://github.com/dirkvdb/ffmpegthumbnailer/commit/3e63ed4a7f092aa6908a417bb800b25eaf3b1e2d.patch?full_index=1"
      sha256 "629ac4ff56cda4066798233c906ca907cfab6c4e36e1d0fb25ead4d7acb1eaaf"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "651e4186281c8f77c76519f282e821795ce42b7cb7a11431c4e9e0ca1fb5a10e"
    sha256 cellar: :any,                 arm64_monterey: "adf8f9ce013151edad436ae7462fd286a9c9bc3c04abe10c5541887c40b6dc94"
    sha256 cellar: :any,                 arm64_big_sur:  "cb6e19606a94bd012f7890b5cfc59b3f8d18344552b4bd195b7648ab9e1b5abb"
    sha256 cellar: :any,                 ventura:        "81f5f3ff321630d5ea8f7374716fd7adee4714a78c95af9ded1def1ea483af9c"
    sha256 cellar: :any,                 monterey:       "e4a182af14a980343f9d45f38e392df82d7640bdbbc12f69670378b815028852"
    sha256 cellar: :any,                 big_sur:        "2c33a50328d3ba008168f7cd139196d566179f119ae9a780ce5e7a52ef5d5142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c627f97157285b874faf076adadae31b0b080c64813489227ee669e320ab7f15"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_GIO=ON",
                    "-DENABLE_TESTS=OFF",
                    "-DENABLE_THUMBNAILER=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
