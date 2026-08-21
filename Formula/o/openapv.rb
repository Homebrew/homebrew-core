class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.3.0.0.tar.gz"
  sha256 "dc5cd1618a07e8b340e12562cae37d612b3a1467ee80d986c477165ae602a37e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "abcd874dce7e4ac8577428fb08bf93b1f839d195b70664f01bba068d087df1ed"
    sha256 cellar: :any, arm64_sequoia: "8df78dbe5b900706b49d6852bede6262b4d1c1b105828181d43dd83546e26e4b"
    sha256 cellar: :any, arm64_sonoma:  "b70a48694eb92a8e7f12fa27b7225dbbd5f96b76e6add885d60fd16850529c97"
    sha256 cellar: :any, sonoma:        "f8be2589dd2e7b95901da0cb88cd93d1523004c73e37569d44414aa8933596e8"
    sha256 cellar: :any, arm64_linux:   "c14f3f9dc3bf5c7b3d1c5ca7bf6065b5dcd9b447dd2d3e7515ad55b2b4a8a239"
    sha256 cellar: :any, x86_64_linux:  "1e40f77c375b513d71fb4d7197ccb5592f6c1ace011aed9041e319509b2ad44b"
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
