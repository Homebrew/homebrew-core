class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "69b7ca638a817d515fa9279892efacff3a101581800ced295ad901259d62e6fd"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "039cbbc9fbcbb8eb75d79ea9754787c51ec10400fa05a3f68dc222447c7e7a44"
    sha256 cellar: :any,                 arm64_ventura:  "73c9e49c2d91af5754c9d42b2d0ca42ddf628b1ac2456e09ea8b95713c55100e"
    sha256 cellar: :any,                 arm64_monterey: "867992ee6fa2f15ac2080c57c548bcc5942ad45b3e4e3c3118582cbb4a1cf89c"
    sha256 cellar: :any,                 sonoma:         "af6f960dae972169c4f9dd534ebc799105149366e5a658bd5002bd797bad614c"
    sha256 cellar: :any,                 ventura:        "1d1f00e95983894ab3e20f163b6d70adb74966ae03519091a3ff0e5acab3a3be"
    sha256 cellar: :any,                 monterey:       "04da97469d1bbcb2340ba8ceb49cea2d58b743818a14decb08ebe01512ed3f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1554fd181e3450042b83fafcd54492d5ead0366cd6159a40c044107d2e4806c8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "fmt"
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
