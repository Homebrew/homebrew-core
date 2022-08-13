class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/v3.04.tar.gz"
  sha256 "a2a380fe653f83445153b2043cb00fa3ac63464499e467aa3d1633b715dec1ed"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "220f72cc369ab7e69b3547f6a71e4c078dfeeec1485e6a331eb4755743c529bb"
    sha256 cellar: :any,                 arm64_big_sur:  "4a7a98f3ab3ab91232086cfc10a448f8ef1df4d94fb664550ba970c7fdb933a5"
    sha256 cellar: :any,                 monterey:       "e8f1907b5f376fb41fc5a72f4b1965252cbdcb0c871c2469c8c8bfabad0f438f"
    sha256 cellar: :any,                 big_sur:        "72cbbe10f0973578f4137045f1bd9278a18c4f207f7ea396d46d4e4c18241465"
    sha256 cellar: :any,                 catalina:       "8fc16b833cf8a37dcd54289bb3927fd9dd7e672e8ebec4029f8de182e161f25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daab2851756390d5d1a854c2f03fde280e296ef69ae631198db4c13b327b753f"
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
