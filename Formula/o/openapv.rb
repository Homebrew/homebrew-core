class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.2.1.3.tar.gz"
  sha256 "cdb9fb65fc68ba06bf79e2dce8c837b0e03e7c2d721a49f6459586c149e447dd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6f538b5b011de386525413a09e82417537339c86df9e93de80f7027203ddab46"
    sha256 cellar: :any,                 arm64_sequoia: "1835ea4b5a24613cf8e53f5c013ee4bbfa374f31150f3882a329c829d7dcd5f2"
    sha256 cellar: :any,                 arm64_sonoma:  "fd42e96892caac4a84f251ff2905954d7d487ef151c0414787b0c0eabfd80faf"
    sha256 cellar: :any,                 sonoma:        "5244cdb3a5835f1d44976e822be1f9871fe94e4df36b4256383c5912a0d07abc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd9b38a99677d5a016cab74e6ec6bc1732710227f3dbd46aa64507e5020ac446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e19b68fdb1252c5d5fd31d9f1c30d3b4dd705580d6b1b3796bf53a3d7e9af45"
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
