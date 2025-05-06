class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8aa9e5b8f90a6aecdb85e83786b3543afa2a414738049447fd3ba5d1afef519b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67dd4fb63aaa44517a0cd5e239fd735812ab09b611a12ab7346278ea578615a6"
    sha256 cellar: :any,                 arm64_sonoma:  "d7bfff91cb2a3462dd93531265b2e7a95119cd5f623db95e6942ca16a85c89cd"
    sha256 cellar: :any,                 arm64_ventura: "6525b026355512b3fe07e8c46cffa03c2d06c00cd228446a288398f750028119"
    sha256 cellar: :any,                 sonoma:        "aa0e9510b7481c84a7d029a527e872accd48054962ce9a40e65dd4f5eb034fe0"
    sha256 cellar: :any,                 ventura:       "7adc49880f296aadde444b76aece62e0b2889b2db932e3102f8ae65d43d0b06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d6446660156fede7509431a1d735df39f870f4a79251a727dd263e807f69567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7288c750bf652b87b4a78638fa09835ff355dd40e053b4216b08a5445dc202cd"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-cal` and `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/mqtt/mqtt.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_mqtt_library_init(allocator);
        aws_mqtt_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-mqtt",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
