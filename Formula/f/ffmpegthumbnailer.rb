class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "56816a9e3f9fc2a86d37cbc970933f826937ddc4e48733748085ca72ffa776d6"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    manifest_sha256 "caee2c87fc7c333b5a3677a5451d9cf4e93bd362e3d8841b6618d1d50549847d"
    sha256 cellar: :any, arm64_golden_gate: "44ac2bd1a2ec8b9ef5735bb584d6e04e7b7818bde0504297bc05eab7f924d3d6"
    sha256 cellar: :any, arm64_tahoe:       "7d65e981eb6264d0bedf3d2074a4237592584965338c96b8ad0caaef1f4973f5"
    sha256 cellar: :any, arm64_sequoia:     "591a4c5834c966eebbe9169314522427c2eaccfcf2c3f63c9b2ef4836ff8276b"
    sha256 cellar: :any, arm64_linux:       "e3fb44f5c0cc272abf81d8da91521f5cf3ade8925c4ae2894d2ec80b9f396bad"
    sha256 cellar: :any, x86_64_linux:      "bd0df36ba23d5cdfc11efb0452b0ced7386f1acb01ad6ab5cb25dc21d0562961"
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
