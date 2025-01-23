class AwsCMqtt < Formula
  desc "C99 implementation of the MQTT 3.1.1 specification"
  homepage "https://github.com/awslabs/aws-c-mqtt"
  url "https://github.com/awslabs/aws-c-mqtt/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "3854664c13896b6de3d56412f928435a4933259cb7fe62b10c1f497e6999333c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f71ac6a29fa188ddd70bd7870f7665b4757e71fc82737cfe912c728939763168"
    sha256 cellar: :any,                 arm64_sonoma:  "d8e0c8bc123dbd4cf4af878c3c89814800ae1d96c21407efc73a81e84e0d22a5"
    sha256 cellar: :any,                 arm64_ventura: "419d0e2564f24fa36aa02b40bb3181bdc9021d18f039113890ccc6a182ae4f97"
    sha256 cellar: :any,                 sonoma:        "5aeca1f69688ac8c0b8216d03758d202f5707672aa832748771708db4d3a3109"
    sha256 cellar: :any,                 ventura:       "73e51202918b3786afd558b258e7df44f5af15427ce7df72e10ed0e8e7729858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b29582b715e70f1563489af2613c25683a7c6e3188dd9ef53ac27d7d6484f21"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]
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
