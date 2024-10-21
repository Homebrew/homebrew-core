class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "faca25847372c28cd2413aefa0603939f7cf27b3da63d44b2098d1dfc6ba447a"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b05ac468d198d998ae0c898c9fc945c94983f6553f2cd090e875b8662a1930b2"
    sha256 cellar: :any,                 arm64_sonoma:  "46cbe7591574b20c78783a75531b03d6023940bfade5e5ad6939cb5f7177c89d"
    sha256 cellar: :any,                 arm64_ventura: "dece6252e632da7ce099efc42887490b4a553171a230dce1a3abb3cadd9bdcb0"
    sha256 cellar: :any,                 sonoma:        "863d533a61288d03623e1cdf452cacff8b0cbdac3371ce1d08d393f0f0a69b85"
    sha256 cellar: :any,                 ventura:       "6553ec80fc667db42ac118df76e4eca294af7cb1e593ab66bcfce2ad28f0959b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d8dba1c0a8cb772bf4f728603d1f6a766a329c9bf7e0efe23abb2eda8b7ebb"
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
          vatek_result devcount = vatek_device_list_enum(DEVICE_BUS_USB, service_transform, &hdevices, 0);
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
