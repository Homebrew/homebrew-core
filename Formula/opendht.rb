class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "caa5ae20a53bb5ddaaead700bde501cb4b8b411375d2b8c199233e235ab0e4f3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c47ec54a74b27e7c1fe4e5cb9245b44bd64a81f3a84169e64331202835ebf0b2"
    sha256 cellar: :any,                 arm64_monterey: "bfd84233086fb8ecbb4f920cde9b0b5440b8bdc82a3c8cb864171bd4862551bd"
    sha256 cellar: :any,                 arm64_big_sur:  "8e3275f216ae19bc923b37f13ea36382de4e3bcb834984fe2edb1daf6efa17d8"
    sha256 cellar: :any,                 ventura:        "b90fcb95087da7e12ea792dec26a9b2aead0549a68e62751fb655e6c22e6ff4b"
    sha256 cellar: :any,                 monterey:       "68860d2c42df668cc8875d1b10140814fee27e6e3e93a47c4d1ec80f8df8d3ec"
    sha256 cellar: :any,                 big_sur:        "f4f3207ffa9b907c9c7423917904102c0de482962be2db82a6a82d6544bd366d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf26a63005f858bc76b8198c096f8e3e08af8ce1023d0d2551000cf0cddfb8c"
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
