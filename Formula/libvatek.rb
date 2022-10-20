class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/v3.07.tar.gz"
  sha256 "4b65b89ef4aa010f987ef9b59cae06903fd2d086d4f7346c53402efeb9035d3f"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bd9c3029551adc22d05acef0fb78f322c6505cce46d40b50b2486b1c3466a4eb"
    sha256 cellar: :any,                 arm64_big_sur:  "65158bde78c394806c6232ddca909c881a9192088df753f9e65ac5f0afa977f0"
    sha256 cellar: :any,                 monterey:       "81118b84a4a2e089c5ce48920ed5bd79e2f1474124d9f241cc1f0f800e1aafa0"
    sha256 cellar: :any,                 big_sur:        "f007eff965c0108c4ffae27a3f056de3f823a9034cbfc37e268391c70bd9f1c5"
    sha256 cellar: :any,                 catalina:       "e29b6c6fec04b8b6321e31b3e9b3f6926d3f51b00bfae03502de40d690a34834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3068685b9da4d718785ef18b75d3baae25003b3a6976c48f4a6fa2cdd468786"
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
