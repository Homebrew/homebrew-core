class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/v3.05.tar.gz"
  sha256 "35cabadc9a626460f030959ed86ad8619ce070ddb5fa528abf15dfa34c10619d"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e5cf4d77087718a4e0eb9442a3711f755d33addaf57e534e81f79d6a96be89a4"
    sha256 cellar: :any,                 arm64_big_sur:  "de11f06a7c23727ce70d3cb9c48f70d35a42f1824ad04a306f89f7e18b970c7d"
    sha256 cellar: :any,                 monterey:       "68295da03b7831b568b396297668674c0749648067920172a2c24da373e9bd25"
    sha256 cellar: :any,                 big_sur:        "06dc7b585a2d66bb9fd642a218f6037aff52a0bd53179b642b21145e632491e3"
    sha256 cellar: :any,                 catalina:       "3613ba84bc530faee9f59b30a6a37d2857baf38d698faab6d90ced6359b201fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a1b8ab023dab39bc9613c6178d064996725a900865298a3220e058b66f74a5"
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
