class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "ef30dc5249dda1a4032f5dbba525988ba253d7a76a24183062960693367fa0fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3591560854312c572ed9c11677c943694c80678a85fd0582d16edbe044ed51f8"
    sha256 cellar: :any,                 arm64_monterey: "4df41a97c70aa710238d97ff2c2ad2903f7108f37e0217a1a4312feb93a7672c"
    sha256 cellar: :any,                 arm64_big_sur:  "af967299ae1d00355a710b343663e61e4b9e196962f49eaa86f9da2f165213bb"
    sha256 cellar: :any,                 ventura:        "66890f1f522a6a36bb7ad106519f8dcd7447d6601221a7380e43478bdeef160e"
    sha256 cellar: :any,                 monterey:       "023bf901b9283a9f8485625a02995024d993f0eca508385a726a2209778e95a7"
    sha256 cellar: :any,                 big_sur:        "0f33bcc96fe7586c9f570e0aff77e257a7f1639469193bbacb0250d8ae371666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e502567e2f1fe880488a7e0b7bfd443afde45de84d06eb9a53877ce1cee361"
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
