class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.4.10.tar.gz"
  sha256 "8077958fb7006612b9b9758095461d8a35316b4224184f10cef785f0ec7031fe"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "fef4bab7d51116fd0623ea3efd66e1c398b8d51e3e7586f5800e30334390a33e"
    sha256 cellar: :any,                 arm64_monterey: "b89841268c4e43ec61bc3ccf04c6697cca4f7ea4c20ca2a41e1454693e4fcdd2"
    sha256 cellar: :any,                 arm64_big_sur:  "1521af7886abc22fe7a00e4deca02180a88da2351bbbed5da02ed84ee8802d08"
    sha256 cellar: :any,                 ventura:        "a6ffa2047d3697f100b9a34465bd9eff6671a7b72e68426b5debc306a036c42e"
    sha256 cellar: :any,                 monterey:       "b801fa3a80c258a64c53a493f0980066fbdeeb4f8872ee71a44fe6c4c587da50"
    sha256 cellar: :any,                 big_sur:        "d2591ae69288c30679d1abb952cd2a56432946878a6daeef430753a27bef83da"
    sha256 cellar: :any,                 catalina:       "94df17098c2d52b3921e5ba236e22aa4f308528c441fde2c35dc1ad6baca5071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f5e03c9cf7528669308ec88846fb29814277ad073de616b1812696b2dede1e"
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
