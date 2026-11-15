class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "0d88f16c3173b799815a39743df3fb1e1f4da76604b9f6fb391d6af41017bd02"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b8bfccd9a2a4add58a338cba78fb4b9038f77070480feb4a1f40edb7954fb714"
    sha256 cellar: :any, arm64_tahoe:       "84d53a0045df8178a8b159aa3c8287713c78c0c599eedb1bb498dec1fe6349f6"
    sha256 cellar: :any, arm64_sequoia:     "a7ab83e0a0ae4a38d225a771a0270804a4e32aea08531446adfb8bc8bf713eea"
    sha256 cellar: :any, arm64_linux:       "c5d0a3e2cb3b22e5d5ef94c5f5f0ee28c032edaa71149f529f657d5c7e7ae146"
    sha256 cellar: :any, x86_64_linux:      "84b4a132abefd4cf8acb36790dcc2b578d6727d0af431b6593621d1c18914b05"
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

  allow_network_access! :test

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
