class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.3.1/apache-pulsar-2.3.1-src.tar.gz"
  sha256 "f4541182384942f59a83fd3150d3c46351ed443b159520296d69ae0ae8612dd8"

  bottle do
    cellar :any
    sha256 "0eae580ce77103ead20caca7c819434c520e9f8bb6dc54a401fd77cf6d3ef3b6" => :mojave
    sha256 "6e9c32f6d3aaf9b2784369d4635508305350fb582801e96f1657018cb532d853" => :high_sierra
    sha256 "b4fcc22c96d7de8d27ade399592a53bc73102d1b97a05e8d0b8ce12eac3a307c" => :sierra
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
