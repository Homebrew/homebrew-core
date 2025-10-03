class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.2.0.4.tar.gz"
  sha256 "1d8d31b0758d4b968d9b2ab483b3edb6de3440edcb27f14801ef42d6f2368e55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56c6e41825fec4f798910260cefa1b449eefcc11abf0d261a46b74d991d800f1"
    sha256 cellar: :any,                 arm64_sequoia: "2e887283159afe070ce1e246a3dd27dd699284fa33127b0baca6d4fe92d456cd"
    sha256 cellar: :any,                 arm64_sonoma:  "9ae8b4bf546d07efac15c7d06dc4bb036ec93cdb727324cdbb6d2bab609f8a05"
    sha256 cellar: :any,                 sonoma:        "d3cff51a1604c8afa0e75b19daf7f095abb886facb3e99a4adc857c379c437b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edc20d196b0b6be866e6995749693c9acbe0b5b5539b3ac4a120608e8420cb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d951fa78b8a04e559cbf94c91ade64bec0d4d24234d9357eacdc224f5de162"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DOAPV_APP_STATIC_BUILD=OFF",
           "-DCMAKE_INSTALL_RPATH=#{rpath}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath

    system bin/"oapv_app_enc", "-i", "RTn23_80x44p15_f15.yuv",
           "--input-csp", "2", "--width", "80", "--height", "44", "--fps", "15",
           "-o", "encoded.apv"
    assert_path_exists testpath/"encoded.apv"

    system bin/"oapv_app_dec", "-i", "encoded.apv", "-o", "decoded.y4m"
    assert_path_exists testpath/"decoded.y4m"
  end
end
