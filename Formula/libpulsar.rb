class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org"

  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.2.0/apache-pulsar-2.2.0-src.tar.gz"
  sha256 "a3b1940a803043bb2c365ce9df657d15bf9aacb3c9ff5db86a79dc4374033f08"

  depends_on "boost-python" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "openssl"
  depends_on "protobuf"

  def install
    cd "pulsar-client-cpp" do
      system "cmake", ".", "-DBUILD_TESTS=OFF",
          "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
          "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
          "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib",
          "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      system "make", "pulsarShared", "pulsarStatic", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv)
      {
          pulsar::Client client("pulsar://localhost:6650");
          return 0;
      }
    EOS
    system ENV.cxx, "test.cc", "-I#{Formula["boost"].include}", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
