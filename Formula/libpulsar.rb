class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  sha256 "e1d007d140906e4e7fc2b47414d551f3c7024bd9d35c8be1bbde3078dc2bddbc"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d5954454a678d3b0af7bbcaa76397840de44410d7efdaa863112ddee67d2d99"
    sha256 cellar: :any,                 arm64_monterey: "4f3ea95040aedcc6da3fa08b643034bdd6816403bc1e4805461a6c5902d5a689"
    sha256 cellar: :any,                 arm64_big_sur:  "5327d0e1eb17d36b7bf7ce7950852f7eaff9fb58e560e883a7018397165572a4"
    sha256 cellar: :any,                 ventura:        "3013318354bb7fdb44cebd471b75b586764693f1e2b19cd61be66398bf857fda"
    sha256 cellar: :any,                 monterey:       "164935fb11d0a181bef72b449c7dc3fed659c7c5d7f386b2cbc4fdc7df635977"
    sha256 cellar: :any,                 big_sur:        "e2880b265a37eb4f83f3d1191c79eb09e835b244a7ca8b6dc70feeb4cd47410e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bdba767f277220ec672188041c9fbb1c770e6339286727188ff66727e043c29"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_TESTS=OFF",
                    "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                    "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf@21"].include}",
                    "-DProtobuf_LIBRARIES=#{Formula["protobuf@21"].lib/shared_library("libprotobuf")}"
    system "make", "pulsarShared", "pulsarStatic"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS

    # Protobuf include can be removed when this depends on unversioned protobuf.
    system ENV.cxx, "-std=gnu++11", "-I#{Formula["protobuf@21"].opt_include}",
                    "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
