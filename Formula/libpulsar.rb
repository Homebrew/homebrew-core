class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org"

  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.2.1/apache-pulsar-2.2.1-src.tar.gz"
  sha256 "3a365368f0d7beba091ba3a6d0f703dcc77545c8b454e5e33b72c1a29905232e"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "openssl"
  depends_on "protobuf"

  def install
    cd "pulsar-client-cpp" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_PYTHON_WRAPPER=OFF",
          "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
          "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
          "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib",
          "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      system "make", "pulsarShared", "pulsarStatic"
      system "make", "install"
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
