class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.9.2/apache-pulsar-2.9.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.9.2/apache-pulsar-2.9.2-src.tar.gz"
  sha256 "66cf22136488aabe443d92284fbb3edb15e1b9d8a64cf498b36236f75af29bbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "908c224c0f902276b7befc8062adb7ea193b7e1396ed22ceb7f299f8f58e08fd"
    sha256 cellar: :any,                 arm64_big_sur:  "f3997f1b6538e06e3d54de79395f30887b316058b7beab2b93bfa321e82f34cc"
    sha256 cellar: :any,                 monterey:       "cd3940c8e1054dbf0c65f265bd017332c4b54fe71593d333cfb7ae9c2cad999f"
    sha256 cellar: :any,                 big_sur:        "fc6e75f09854e1ecf463c1c25c1f5e164bb183cfd27c50fe8b0d5beededd091e"
    sha256 cellar: :any,                 catalina:       "3f07b624418306fee3bc521926bcd110e6856fa73745608b4ffc87c14becbf3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72226d10093040243b71bf8e080e7ef757aa701a4472efda5aacd8c36e19f8ef"
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
