class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.56.3.tar.gz"
  sha256 "a18112df0dc0bf442b58fb754f719be1992ddbba154564db5321729ba340c8a9"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a495c68a1fa2147a5284ff9ac09ee9015d508be22f2219d51264b5f02af017a8"
    sha256 cellar: :any,                 arm64_sonoma:  "050de61de7cf29ea270f129575ca2e3732ea712e3be06ae9fd3ed4a8bf46fdbf"
    sha256 cellar: :any,                 arm64_ventura: "207444c7ce2f58647aefc431b1359cfb073e02fe89c095cf0434576d5980bff6"
    sha256 cellar: :any,                 sonoma:        "39fb346d00062933880f3ef63582f6cd24be974b2c0054edc108f122a9f19b55"
    sha256 cellar: :any,                 ventura:       "e8b1baa16c09544e0d9932d8706c897843e9216f2e0ef7184d374b6a93a12131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60dc45ba36a22fb3e4f679839bd519046c773d437a3ccffe396cc179d5e82b3"
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
