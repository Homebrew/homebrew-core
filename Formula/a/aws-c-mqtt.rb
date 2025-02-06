class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "04abe47c798bf9dcb95e25ea9acd62a35a3f22e58b61c16912a6275c2f8230fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec3a0cfa538ba7f8e02bbc0cd445980acc240d75b70cb2858ba4c5627a8ba3d3"
    sha256 cellar: :any,                 arm64_sonoma:  "b6b121418dac0920aa75ca3b10bead02b5b6a79f3783d9c7351c2d560445627b"
    sha256 cellar: :any,                 arm64_ventura: "b4b5f79e7e68e80c4320490103a0e7efb47e9086c00315057adeb0a0c17f1267"
    sha256 cellar: :any,                 sonoma:        "2e00b83146cb0971bbae4c3a30e7e732701f6d86db186acc90373581bcc2b0d7"
    sha256 cellar: :any,                 ventura:       "71adf2472c1bae222a87696a8dd4855d0cd4a8319b55252878b98fc2a10a86b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b72e7cb9fe37a16d4f8d8a5cb1c0130518a6707aa2fd9172ed5afb2acc72c9"
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
