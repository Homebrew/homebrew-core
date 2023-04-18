class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "9b2acf6a05a65efda366954aa1121bf961040b807e399ed829aa582987c12e41"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9d0999453ac71c67535b9eb5864720a604afb6ad1bbde960a2d7d1109b7e5cb7"
    sha256 cellar: :any,                 arm64_monterey: "468967ad08d017b1b64ad39d611f9929d8c333a4cdc3dc2ed4576c7523319779"
    sha256 cellar: :any,                 arm64_big_sur:  "0b4e60467a3d4248b54265f6dc9e0fa226671ee4cfe041b7605ed1762ae7915e"
    sha256 cellar: :any,                 ventura:        "35f9b1af66e2e5f24067e86cd1490b21f19aeaf92f1e906eec5e63cb72ffb455"
    sha256 cellar: :any,                 monterey:       "e9019d2eaf73d5ced3eb1ae993b08b9f49e9f6975b02f3070c38bf8952daa223"
    sha256 cellar: :any,                 big_sur:        "d1e1ee7b751b943d0b21e6232f9fa27a2ed37ef34ec59026b319841ad4e1aec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f819c2fc688ab01c58d34916a9e31a3895a36732ffa4525feb800cca8373ad8d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
  depends_on "nettle"
  depends_on "readline"

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
