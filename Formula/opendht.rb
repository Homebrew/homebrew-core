class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "49dcdd12120678f3548a47206e60074ef0f4eb798ca5d213efd5cf1e2d70127b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "efc6aaca20d3fc647851acf02dd77a586acf59310371d3eb78c21d6d980608a8"
    sha256 cellar: :any,                 arm64_big_sur:  "5c8823d4e847fc0b236030fb9e8e5205cdbaf738e2b01da34ea253828628c124"
    sha256 cellar: :any,                 monterey:       "610c8f025f559fd42cf2b41d0011b3c7774079facf6a0964d2105b1d5f7f1516"
    sha256 cellar: :any,                 big_sur:        "13b1ab14eef399d44d28c352379bdf3514031428ceb28a683d0af67736bc68f1"
    sha256 cellar: :any,                 catalina:       "76229aa202a91b4f808c208e6ff01df1059977d21cee45dbdb65ce19029499a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd0438e39a5ca91b5d052b6b2ed530b51696bb32cfe6199c146931c2bbcf7e52"
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
