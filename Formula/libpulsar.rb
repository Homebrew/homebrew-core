class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.2/apache-pulsar-2.4.2-src.tar.gz"
  sha256 "4b543932db923aa135c4d54b9122bcbdfc67bd73de641f9fffbc9a4ddf3430ae"
  revision 1

  bottle do
    cellar :any
    sha256 "6b12f4f3c5051a88202bc05ab31f7c95b9f814a4249875ce45a875c175416e66" => :catalina
    sha256 "59b3cdb95e017aafa689ea03998ac52bbab7b49265d68fe1a9cd4ebc368957d3" => :mojave
    sha256 "1940bc07bb364d93bafda7ce2f377ef2ea18bb0daf31427c9ef318dc19104b8c" => :high_sierra
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
