class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.0/apache-pulsar-2.4.0-src.tar.gz"
  sha256 "b4666cade20f7e7c01b9050813a3975d4e0fba36f0ab058e39e41b30e029dc05"

  bottle do
    cellar :any
    sha256 "8364ac27872db23b3793ad5fbb360d062e90b281f3d67b3777207b1db5311530" => :mojave
    sha256 "06a9ae40b3a1128f3dd4fd1e16426b7313e46d4cb31111b252600e90837c25ee" => :high_sierra
    sha256 "8de61a6470b719f5f491977674d3ae2e18c08452c556abe3a1b70bd43af79bb1" => :sierra
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
