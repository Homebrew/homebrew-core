class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.0/apache-pulsar-2.4.0-src.tar.gz"
  sha256 "b4666cade20f7e7c01b9050813a3975d4e0fba36f0ab058e39e41b30e029dc05"

  bottle do
    cellar :any
    sha256 "8fc74ec92fd3890d5fc0a0dddb0563f9622544dd447a31d99d287777178b7344" => :mojave
    sha256 "95edc7a22d9731ab0555d8deaea9e9a0735e802547f54dbaa1e4cabf1ae527da" => :high_sierra
    sha256 "b0d95a3f5845e98a76297cab3a07227d1f7cc19212252467ab0b3a72b029ddf6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "zstd"

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
    system ENV.cxx, "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
