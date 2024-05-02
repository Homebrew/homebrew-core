class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/refs/tags/v3.10.tar.gz"
  sha256 "cf445ba21c78ddc013b8f123719543156774e0878183dcef058611871d34ec45"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cc06fb62e01663ce4e68e119f9c250bfba4a0704e312589f30dda8e5ea173ab"
    sha256 cellar: :any,                 arm64_ventura:  "a83491dc4361af9536e53467b5fdbbd0b43e0591c0c452c76c5cc7599f101ac8"
    sha256 cellar: :any,                 arm64_monterey: "c9d734af1f8c9040363632e95b03455aded913f0acedaa1047c83d35f680f905"
    sha256 cellar: :any,                 sonoma:         "89ed2d18d0b47530be1ce7a729c3790e985261c63ff7974e47e0b8985fca9c1a"
    sha256 cellar: :any,                 ventura:        "dd44e932338325cfcea3ae83fee997d6266ea77b507b35bcb7872b24c023911c"
    sha256 cellar: :any,                 monterey:       "bb080754bdfd077151049207517de79ed2fc6fd346ff465f55cca79bf55fa6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9fa301f6a5ca4ad23ccfecb3d2ca72e4df979b355ebde97e9bdf3c7b78bd69e"
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
