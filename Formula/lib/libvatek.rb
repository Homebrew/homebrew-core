class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "293a9d8f271fe960c987b0c620bbc1daacaf1fba00374c3431cab990456ba516"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ca6f454928d6f29616c5e0fe1bf3703ce762e4c0400f1cce501fc3438d88794"
    sha256 cellar: :any,                 arm64_sequoia: "1e231d20c397029d363b48b1d685a4ed1710ea69e1cf4408c7bcbd758418b425"
    sha256 cellar: :any,                 arm64_sonoma:  "c081fd50a34d94aefe63df4c343975be869bbfad3b0215a5daaa6b306a8b46d7"
    sha256 cellar: :any,                 arm64_ventura: "adbf2c5ff43b6d27ff6fee7e2e58c8a4468387e50ae96c227ffb91dd055f94f3"
    sha256 cellar: :any,                 sonoma:        "1451fcbafaed9feedeedd0acb7b96a08f5b039ee713e308b569162680eb125f9"
    sha256 cellar: :any,                 ventura:       "1e5c0363747da7a46a013899694315c0d01226c2251f7fd00e208218dd99ac53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "747345a965105bd39b8a4c663ae8a255a99c29dbe834e3d2353f8af362c148cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d2064162ff257be56fd39c20b6af3626943f328097a8e715515d5e4ea2c592"
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
    (testpath/"vatek_test.c").write <<~C
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
    C
    system ENV.cc, "vatek_test.c", "-I#{include}/vatek", "-L#{lib}", "-lvatek_core", "-o", "vatek_test"
    assert_equal "passed", shell_output("./vatek_test").strip
  end
end
