class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/2.4.6.tar.gz"
  sha256 "0109622ac806306ecbdd816a2a516464432c0ed24c39c0f4af3d5683cb04294e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a2f7dd11fe8afe8d408d8167c94ad3b85e9e1ddfb6a121f74189608d9bc55f2e"
    sha256 cellar: :any,                 arm64_big_sur:  "4dcf90d88ccc50da7a4d0abaa3df907388d87847936957f0cd8b09343443b135"
    sha256 cellar: :any,                 monterey:       "7a0aaff6274cd519ac1be1aa3696970df95d9b778ebc1c9bb22da5891efe4626"
    sha256 cellar: :any,                 big_sur:        "ba655f9475c125eae4279a91545c31209286272dcc5cf5745df15f3ba0f6635e"
    sha256 cellar: :any,                 catalina:       "c9c271677912a00717de607fde96147601b028e9810da7eed07c4f21eb1f0691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c746364d0eca21d2719d53e53072706cb6a56c2388e2c5d488e98d80b663e5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
  depends_on "nettle"
  depends_on "readline"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENDHT_C=ON",
                    "-DOPENDHT_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opendht.h>
      int main() {
        dht::DhtRunner node;

        // Launch a dht node on a new thread, using a
        // generated RSA key pair, and listen on port 4222.
        node.run(4222, dht::crypto::generateIdentity(), true);
        node.join();

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end
