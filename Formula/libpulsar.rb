class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.6.0/apache-pulsar-2.6.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.6.0/apache-pulsar-2.6.0-src.tar.gz"
  sha256 "70013be17c00cbefecb70962c4f0484a8b4421495b9a9a2ded65cbb19716ef94"

  bottle do
    cellar :any
    sha256 "edc767dbe2f848b050ece0acba4aca4dc9ed19e4c32d92e11323fbee68d1d9e5" => :catalina
    sha256 "af30e5237a5328313c9dd866fa43b83b93a918709fb428a721410f51373a0c70" => :mojave
    sha256 "32831766bafadb2db4ef39ad55d904de3f3dffef45f6ca41e123549913571a22" => :high_sierra
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
