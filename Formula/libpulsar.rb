class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.6.1/apache-pulsar-2.6.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.6.1/apache-pulsar-2.6.1-src.tar.gz"
  sha256 "7e40f95c2eef295bacae70697d452a4db4994725e1fbbde011df1ee383ef21a4"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "94209bb4c61501598ffaade2406bd7e5145befbbe6b5fea4ce1ad8e2316d2e49" => :catalina
    sha256 "fa43531e5a34cc8a5c83de1c503ef66b4568599daa06d5c03f6ca13c714dc3a0" => :mojave
    sha256 "3d6100152e9bd0d5c00ac6b079223ef7fe9f7c55a8f7574263495220e6f210ea" => :high_sierra
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
