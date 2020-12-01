class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.7.0/apache-pulsar-2.7.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.7.0/apache-pulsar-2.7.0-src.tar.gz"
  sha256 "f1e8168b7f2b8bfc06c84f743eb4f3dfa5f8f376f087c5ef1532f998cf56bab4"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "f5d67b97046905fe6f302aa3a42e7390abeb40323e15f56553132f0bf06ceca1" => :big_sur
    sha256 "d6bc669d7592768c72b1b0364c8332900bd0ad57483a5e9d9d62e82a545e21ee" => :catalina
    sha256 "354b23177625a7b3c94ed21188cca719bc051a5db0d0a7facb47cb6bb9317bb1" => :mojave
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
