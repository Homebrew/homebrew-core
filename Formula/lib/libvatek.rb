class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/v3.08.tar.gz"
  sha256 "b2ccf79d2575a9a63faac394e739ed483ed6267039e55cebcb7c4b35bf76122e"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f15bbaf7cd448348d4620f46a35c01775d6d79ba1bd7b9cfc3bed8e474a01d6"
    sha256 cellar: :any,                 arm64_monterey: "2cc74f113ca99c32faf042f1b8bf91ddbf6bfeab54240884c4e442f48abf9143"
    sha256 cellar: :any,                 arm64_big_sur:  "cc0f294eb360e4ddc871dda1f9cf225923707de0e3a1da75f06a3552eaee6bbd"
    sha256 cellar: :any,                 ventura:        "14a8147b3e93c86c3ad6e82894f74164b0804c370caa5ee63e820e7fb5c7d96a"
    sha256 cellar: :any,                 monterey:       "c9c5ea7f5705196cd2cdda4459e3992e91d2cd7938cacd648c3e41553c9d1ab4"
    sha256 cellar: :any,                 big_sur:        "3082ab9f18c28c09f8fa604a0a6c1abfe0b8c0806fd3c92b8cac6c1079e2fd06"
    sha256 cellar: :any,                 catalina:       "0c2cba5352b4acc6b8735a58697485608e3fd4d7eda1b8a8a5f07b354d199942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d008f6ca39f8fa289780c1d4d44494c8186040304817233bcf1418de2185b78"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "builddir",
                    "-DSDK2_EN_QT=OFF", "-DSDK2_EN_APP=OFF", "-DSDK2_EN_SAMPLE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"vatek_test.c").write <<~EOS
      #include <vatek_sdk_device.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
          hvatek_devices hdevices = NULL;
          vatek_result devcount = vatek_device_list_enum(DEVICE_BUS_USB, service_transform, &hdevices);
          if (is_vatek_success(devcount)) {
              printf("passed\\n");
              return EXIT_SUCCESS;
          }
          else {
              printf("failed\\n");
              return EXIT_FAILURE;
          }
      }
    EOS
    system ENV.cc, "vatek_test.c", "-I#{include}/vatek", "-L#{lib}", "-lvatek_core", "-o", "vatek_test"
    assert_equal "passed", shell_output("./vatek_test").strip
  end
end
