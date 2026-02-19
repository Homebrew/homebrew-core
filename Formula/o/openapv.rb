class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.2.1.1.tar.gz"
  sha256 "ee9004f49e5f5a29e52ce43c0571f15b99478aeab8f77431e4c935795117fcd5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a6c585200d7e1323b982173c4f72edccb5722c65feefcd42352151772945aee"
    sha256 cellar: :any,                 arm64_sequoia: "efacc8eb05cf853eeb637b68dfc432619094c2831736fbaccf57ebeb64176d56"
    sha256 cellar: :any,                 arm64_sonoma:  "6b5cfe06092a3ec1dfb99dd9c11325fd15bbf0eac5c2ae25987356fae55a4000"
    sha256 cellar: :any,                 sonoma:        "30c7c42bc17f4e2fafcf5b27180087a129e57af8e7a4526736071aec42e55054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec43aabc25d72134b80e4e9acae9337a2dd15f4679cfdef8df9f3eedc053512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc155ac224a648b4c78b9d179f69029d629815fef8b8aa556dec0f212a5f2a0"
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
