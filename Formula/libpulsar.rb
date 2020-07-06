class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.6.0/apache-pulsar-2.6.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.6.0/apache-pulsar-2.6.0-src.tar.gz"
  sha256 "70013be17c00cbefecb70962c4f0484a8b4421495b9a9a2ded65cbb19716ef94"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "f3999e101d0705cc49f60c15c6e1c3ee11fd4cede6cec74f5d127ab0bccc90c9" => :catalina
    sha256 "ce9297c5c3699dd166feac10467880ab467edb9547aa8a79de24178de83e6e2f" => :mojave
    sha256 "9a72afdd9564a81c16a0cf09f196ba0651ebd2078bac1b36b0c2b2699117a9ae" => :high_sierra
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
