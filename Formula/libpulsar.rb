class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.8.1/apache-pulsar-2.8.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.8.1/apache-pulsar-2.8.1-src.tar.gz"
  sha256 "8e30d0414f840477cad8fc27a09904523f3ff039f7c8570feb6acca047661710"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c6ff21f91a74df5c179821426340067bebe045663d8626a1ad4a1c9cb21cb912"
    sha256 cellar: :any,                 big_sur:       "bc0154f9f3f130b793a9ddbf2ede2c8084b658e8ea3948d15dd90c1068339e60"
    sha256 cellar: :any,                 catalina:      "bc49897ed00c8229f49cc89ad6a24ea49b0e8e5017e4de129165b66ea3d62da0"
    sha256 cellar: :any,                 mojave:        "7248e726666cd83133242b715b9e71208337a22c9c56e7ce9fe71fec03b596fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aaf450cd1d09ac982c4e6073fcbecf6183a5a5edf283b7bbb66467d8975a588"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    cd "pulsar-client-cpp" do
      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_TESTS=OFF",
                      "-DBUILD_PYTHON_WRAPPER=OFF",
                      "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                      "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                      "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib"
      system "make", "pulsarShared", "pulsarStatic"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
