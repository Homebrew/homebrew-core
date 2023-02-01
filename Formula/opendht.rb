class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.4.12.tar.gz"
  sha256 "5144bc4456d396b527b59065064bbc31fbe0d2af5fd052506219a66895791e64"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d65be533e77ba8f2873c95ed36c348d3ec3e29468c9618870c521abad190411e"
    sha256 cellar: :any,                 arm64_monterey: "e18cc1c1a2ff889b2c95e3e18da171df3dab6e2bac418e7c895d84564ac2ee0e"
    sha256 cellar: :any,                 arm64_big_sur:  "dcb7af100019d128de2bdf404037236280e040e52afbc17ff7b9780bef6a7d9e"
    sha256 cellar: :any,                 ventura:        "cdebccfbb52185bcbb0b4241f9e9bb2e657135604d46a26cef232d72e1c17ac5"
    sha256 cellar: :any,                 monterey:       "c8f4cdbbf1a5bd834d87bedd4af57a01bd5d580b72f73663c5f134380b238182"
    sha256 cellar: :any,                 big_sur:        "2eed41eb7825452557af08f42a71a14c1f62a6166febcbe4c84ed46434c3d8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806e8dd3feb6819df61d1da8128947447b71464088cfdef0ce8322fe15f85f4f"
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
