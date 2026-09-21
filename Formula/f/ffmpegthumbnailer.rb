class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "0691647dc054179c358794c643a0968f796d23c015d02283e6ce2cf4173d2e0a"
  license "GPL-2.0-or-later"
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0193c77a95f943dabbcbe867380b61c248cb8329eb3a87bff1eee1e42b7ac63e"
    sha256 cellar: :any, arm64_tahoe:       "6fdc3033c32654fb6a6bd59bd206f4c965644e3671d09accd03890426f87dc2d"
    sha256 cellar: :any, arm64_sequoia:     "d14eb0c87ec7de12c91f47ff64ab5bc2173543352e25e8c165b7d7dc0320ce0d"
    sha256 cellar: :any, arm64_sonoma:      "735269f986f912b1f1758fc291289b507edf07f36e5b99beb75e5b63acf2b32e"
    sha256 cellar: :any, arm64_linux:       "b0825d8022c19995b9fe98e7b465b55dcefa11441de1b57b9d6c9171eb3040d7"
    sha256 cellar: :any, x86_64_linux:      "ca28956efd0d6b2bc39f247417f3ee99a12c2be34055360afd28a552a0eed6b4"
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
    ffmpeg = formula_opt_bin("ffmpeg")/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.mp4"
    assert_path_exists testpath/"v.mp4", "Failed to generate source video!"
    system bin/"ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_path_exists testpath/"out.jpg", "Failed to create thumbnail!"
  end
end
