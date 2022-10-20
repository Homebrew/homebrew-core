class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.10.2/apache-pulsar-2.10.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.10.2/apache-pulsar-2.10.2-src.tar.gz"
  sha256 "20e367b120db9d7daacfe5f26b4b5a1d84958933a2448dfa01f731998ddd369a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "77b533e0db094e541b6be9744f2eba73b8ff164468f00459e566697e7b67786f"
    sha256 cellar: :any,                 arm64_big_sur:  "f619572c0f3888c4d0e8dff5e4d9070d2a77eb2e59d14a8a8a2cd414176adb0a"
    sha256 cellar: :any,                 monterey:       "eb74800a3c5ee750ee67f2211d7fea157f9ce8aee078bf35727dc2d40c5b7e9a"
    sha256 cellar: :any,                 big_sur:        "15ce481e56ce2345e8fda33f5e341732bd3a0e52e2890575b228d5c692384762"
    sha256 cellar: :any,                 catalina:       "dd8405e735229fc1c1504643dcaa604aa62162ad57a64b65368df5ec10e90510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222bcc7bafae875a2bc6d2be86dfe5c3c3776d1d908d6436e36ceebb8dde37b5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

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

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
