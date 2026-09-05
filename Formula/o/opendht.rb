class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "6b52bf081f3539536a93f442e0ea56d0a871eb5b7c06619740c5460c5e338a18"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3f74a08c7151a27bbe96d93dece8c909aaccb047e950b7d7038ffe330691091c"
    sha256 cellar: :any, arm64_sequoia: "ac58f4c0c4ffacff87ee4f3c93b4e50ff7f897c734f05076c31dfcb764dd5ce5"
    sha256 cellar: :any, arm64_sonoma:  "0989b9e4696885eecc975fdeef548d55a798b058edf1a38cf0d1ab3a7c10c434"
    sha256 cellar: :any, arm64_linux:   "7d7e90d569d14db9edf04fec75438db2f678e1d7e10e55100d3a8f6e2224f41a"
    sha256 cellar: :any, x86_64_linux:  "4f591682f73adcb384f5bde72184a4e66ef5fcd6e26734aa1402ab1c03d00f1b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "asio" => :no_linkage
  depends_on "fmt"
  depends_on "gnutls"
  depends_on "msgpack-cxx" => :no_linkage
  depends_on "nettle"
  depends_on "readline"

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
    (testpath/"test.cpp").write <<~CPP
      #include <opendht.h>
      int main() {
        dht::DhtRunner node;

        // Launch a dht node on a new thread, using a
        // generated RSA key pair, and listen on port 4222.
        node.run(4222, dht::crypto::generateIdentity(), true);
        node.join();

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end
