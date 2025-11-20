class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "2d5a667ab13e0312127e188388d61afc54735f6cb9da146b09eb65c6fdad7d45"
  license "GPL-2.0-or-later"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4208ef24df2ecc1b6d087538538b7f9108a419b13d0c455f6de0a45811fcd117"
    sha256 cellar: :any,                 arm64_sequoia: "1af8dc000712c1dbd62db76ec32232584b05a95da58aa411d82465b508c0ffea"
    sha256 cellar: :any,                 arm64_sonoma:  "2b3f63ab1683fcaa0fe365db6ad6b3b9e4fda9519769dc720ef57b5af896ed3d"
    sha256 cellar: :any,                 sonoma:        "b3c4321991578937216445d3f67766b4d45218699934d3478f2a2812d2facda0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5129fe48bf51641f7483742f522542c1c576f67b72865efe3a86225d0b0e69eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef496d6078142b1d8f4bb9aa5cb4d1446227feeabb877e4c6c9464a27229b58"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    ffmpeg = Formula["ffmpeg"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end
