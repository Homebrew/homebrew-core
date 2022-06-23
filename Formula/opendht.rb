class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/2.4.6.tar.gz"
  sha256 "0109622ac806306ecbdd816a2a516464432c0ed24c39c0f4af3d5683cb04294e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4628ea643ebd50eacf4db643578ef268caf6d36cb22997e03a3e7ba3e62352e9"
    sha256 cellar: :any,                 arm64_big_sur:  "45f1759b57ce56111a0f838b68e3b6f02a45356eab2b30c98e82a7a0157c8ffd"
    sha256 cellar: :any,                 monterey:       "60be4832eab64de7ec7e1722c4cb73d310895aea76eb4cc3cdc4d5ab0cee3112"
    sha256 cellar: :any,                 big_sur:        "451cc6185b2968814802c8dfa5d9a6e35310c169121e6a7619c75d54e46fe730"
    sha256 cellar: :any,                 catalina:       "301759e290756606623970326c3923064a99802d46e506d8d17ce3810e9bb804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b372a85ac9444f5aed8ff25813d76c5d6f06f733821ce556b11fb972670d13d"
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
