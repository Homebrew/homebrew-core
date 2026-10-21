class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v1.1.3.0.tar.gz"
  sha256 "38f841ce44e80c40b682a5323b4f3ebc6e339b6071965bc1c705a17d46ab2fc8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2a8715fd76c564d029a4ac0295481b6d412ad22d371e9017905d34eb9877f807"
    sha256 cellar: :any, arm64_tahoe:       "2a11f2037eb3ae23d34b1b7d3bb8d35a1926b06f2dc4f7a3ed46a6f0027db52c"
    sha256 cellar: :any, arm64_sequoia:     "c6e5d28d52c6ba6514ab78fa5e2041c5bdd6c3d25ffa0db15cf22729142cfd75"
    sha256 cellar: :any, arm64_linux:       "669736bc07bf97ad792f0fae3144087aa201547d46455eab62cf03349e12d115"
    sha256 cellar: :any, x86_64_linux:      "4595fa9445d051da79dfff9cbc7aef24f1682e4846c0f996e7e83372f6976eb5"
  end

  depends_on "cmake" => :build

  resource "homebrew-test_video", :test do
    url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
    sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
  end

  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DOAPV_APP_STATIC_BUILD=OFF",
           "-DCMAKE_INSTALL_RPATH=#{rpath}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-test_video").stage testpath

    system bin/"oapv_app_enc", "-i", "RTn23_80x44p15_f15.yuv",
           "--input-csp", "2", "--width", "80", "--height", "44", "--fps", "15",
           "-o", "encoded.apv"
    assert_path_exists testpath/"encoded.apv"

    system bin/"oapv_app_dec", "-i", "encoded.apv", "-o", "decoded.y4m"
    assert_path_exists testpath/"decoded.y4m"
  end
end
