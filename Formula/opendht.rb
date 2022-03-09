class Opendht < Formula
  desc "C++14 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/2.3.5.tar.gz"
  sha256 "fd762832ec82094f9b95a21a6ee54b082db2c81a5860dd24cf0599810df8b1a3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b02071aea1361517a67f4e65099b10df43e9c2d416a2b3ffefc27acd3901ca8"
    sha256 cellar: :any,                 arm64_big_sur:  "db64e0dd355b897f2d07dd964d935f55ce2812a51206ac86a333b1661db371fd"
    sha256 cellar: :any,                 monterey:       "daedd911c92fadfffb35bab2384bf87238f993fa62d30936528daca7d9916454"
    sha256 cellar: :any,                 big_sur:        "a1a3c7456e773fd4416248c49cfc90967899c73a7d0e3afec2464c51be17b5a3"
    sha256 cellar: :any,                 catalina:       "ade9c301decfd041aae026918b44bc400be948d5afe294091c1fd8d993dcd426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b248b4d40a9e4a5eb2dee91d59ac95337c951da68a1d6af87abbb5db330591"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end
