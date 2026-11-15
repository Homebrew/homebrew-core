class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "56816a9e3f9fc2a86d37cbc970933f826937ddc4e48733748085ca72ffa776d6"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "45ea24d61f5136608419650a77691f3849d0b0399a4293bc507f859c43ac2523"
    sha256 cellar: :any, arm64_tahoe:       "c9ff10aee8faa1ee031739de1e434218fd7925801618c48a0da688bbaba0bc31"
    sha256 cellar: :any, arm64_sequoia:     "2b642810fe81ed407220413df34259e81aeebd2dd675f4f80252a68a16551385"
    sha256 cellar: :any, arm64_linux:       "ddf034f5725cfbba42be4acf597af6d42e056eead5603c1ff13bfc9ef0494375"
    sha256 cellar: :any, x86_64_linux:      "80160c522eaffd221af58efccc52d50d6a3dcd59c1555709f14ac1cb737bfa9a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  deny_network_access!

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
    ffmpeg = formula_opt_bin("ffmpeg")/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end
