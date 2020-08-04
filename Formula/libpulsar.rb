class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.6.0/apache-pulsar-2.6.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.6.0/apache-pulsar-2.6.0-src.tar.gz"
  sha256 "70013be17c00cbefecb70962c4f0484a8b4421495b9a9a2ded65cbb19716ef94"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "2e20bd91fc53b59c291a0524b15d0cf942ef26fef4552699b3082b41bd07ee39" => :catalina
    sha256 "c17fcf1949065775391518b91aab30bc416858cb650da1ca523f90a328511553" => :mojave
    sha256 "0ce9119dfff0783461055b0581ea12ce5e6630920edf509df111d5b0d781e23b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
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
