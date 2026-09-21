class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v1.1.1.0.tar.gz"
  sha256 "956e6e2cc822c63af4c323bf86464f1186171314e67e9c5153f58bd875538470"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f99f6ff9c9c2b5847fdc00f62bb469ba6222e02f69900ef07decd14b20ba0bc4"
    sha256 cellar: :any, arm64_tahoe:       "d69ef2c9c4bc0550c7dc429237548d4cea60ac59df962fa0391cbdafde4401f9"
    sha256 cellar: :any, arm64_sequoia:     "4a75eaa35fcb10d6e64304bf026c2992137a82405b23eb0fa9036fd23497eb0d"
    sha256 cellar: :any, arm64_linux:       "2e01f0e76f081c97f787611b012bce9a41b4a4ae6a94d12c0f52b6786fbb4520"
    sha256 cellar: :any, x86_64_linux:      "a353e9980ac4c9a3ec006ac3fa73e17627d51bbde120fc36d3a3a82a31278615"
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
