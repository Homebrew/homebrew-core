class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.2.1/apache-pulsar-2.2.1-src.tar.gz"
  sha256 "3a365368f0d7beba091ba3a6d0f703dcc77545c8b454e5e33b72c1a29905232e"

  bottle do
    cellar :any
    sha256 "63b0d3fcf20e333a2fe5d60fddd103de2597156e1339aa7450d157341de19dbf" => :mojave
    sha256 "58d7ece9b66f7ec7b7a3874e721fba493b7b18f0dfc2b5e12202d45c1a36c527" => :high_sierra
    sha256 "a4fb175e3280ca1f3e40befdf8568e3f43191c093bafe90aa30d743ce6ef5dc1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "openssl"
  depends_on "protobuf"

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
    system ENV.cxx, "test.cc", "-I#{Formula["boost"].include}", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
