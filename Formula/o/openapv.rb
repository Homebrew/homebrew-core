class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.2.1.2.tar.gz"
  sha256 "164106e8c4f096f5e8df24eef14fa0cebb0c3d65aa32db4616672aaee029ff18"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "933d57861d3f7340895b4d01b1b0d549db7dac5f5ec5b8593a5305b7777e6e88"
    sha256 cellar: :any,                 arm64_sequoia: "d91aa9b30ecb443599c67842bea2978a877a7dcf300a3642bc8104eccf86b352"
    sha256 cellar: :any,                 arm64_sonoma:  "f1b704f065e7cb2a8cd023c1591d43b5145e8d266ce39989efbad8387c21f7e6"
    sha256 cellar: :any,                 sonoma:        "7680708f60dcd1f8e068d641b29ee86194be725038e830ddfdd91cf9750565e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb82504ec64e47445d784258a285d01225ab32092873d8af6a6cf7a34de2ac31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a010d64a5d9a4af3950ee99548d61ba5d12703793729ef55fcebf625aaa763"
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
