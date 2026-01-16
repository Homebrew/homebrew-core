class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.57.5.tar.gz"
  sha256 "6fe337090becb668289178b20dfce07d553d4a71fd54ffbfee18b45847bcdee4"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61906d4a9aad317c61e01557f21c32fa4216881418a1ed964ad4b794fda76b9f"
    sha256 cellar: :any,                 arm64_sequoia: "4607caac5dbbb6d786ecdd87a79af05388ea89dbe33ee46713b2b5413b30f0f7"
    sha256 cellar: :any,                 arm64_sonoma:  "3a300815638cc20d8f66333c9f8c9435c05f1673840abc2352d47830f8efd41f"
    sha256 cellar: :any,                 sonoma:        "3be2ae68b0520d4a115d7afa6a72ba592f99450c52258938134c3b4ee1b1e1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b620880ccbab3c9816d77eeb28bde34b78798ff8e5e32b945b3b017a28e8d075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10528158e058c91a71dc792d0f6740249403b7297323bc7e07a2b9b937bd821b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glfw"
  depends_on "libusb"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].prefix if OS.linux?

    args = %W[
      -DENABLE_CCACHE=OFF
      -DBUILD_WITH_OPENMP=OFF
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DCHECK_FOR_UPDATES=false" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
