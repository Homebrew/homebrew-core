class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.2.0.3.tar.gz"
  sha256 "9da0f758534d6243cd6e5c5ca46404e6fdd7e298a17da50b676b71c53ce6a083"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5d59d46798eaa7a2f7aa0128c336a8bf69751c83607e1b76beec38e98c9b40f"
    sha256 cellar: :any,                 arm64_sequoia: "4338fcad05732c7704ac85d7cd094c9c75589117def176e24270449033aa28ea"
    sha256 cellar: :any,                 arm64_sonoma:  "fe0be30a5c3b1afd0be83b2e0b8cf4169e93091b57a467d4068138162c2ee551"
    sha256 cellar: :any,                 arm64_ventura: "ecb5318dd94fa54e445075fbe45944f3e08b43cae0b421c99a4d0bbe611147ed"
    sha256 cellar: :any,                 sonoma:        "4637646fc6477fe69c9ef3d549364285866e3b157ac1ad48e602180b8fb5515c"
    sha256 cellar: :any,                 ventura:       "ed1d54e21f22638ebac413307f7044359b239963d0e1c1039f3aee7e46d9a776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d71d90a898bcdfb6b6ea1e2c7c36e03871db39c898e1ad4c1bee746df8c42a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5db440d8e9c86855e484c759e45fe59ac8850485a9616313147b2164c3499f5"
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
