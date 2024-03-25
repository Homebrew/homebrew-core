class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "f48708c4747c75020d06de250541d35baa689e54f292b955eaab15ebf33f27d5"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f43046cb2042ccf5f68fbdff9babac75dded5f4cb63b6b1831671eb7d9ae3b0"
    sha256 cellar: :any,                 arm64_ventura:  "83ac006f7b3d4f6cbceb2e3d60d230cd04d6b548508121ac53a9edf85b3b7d16"
    sha256 cellar: :any,                 arm64_monterey: "0b2f14146c84a1c6acf3255c7ec3632e78f7aa494ee8841462ebf0875cf103aa"
    sha256 cellar: :any,                 sonoma:         "193f5292ace5065c09351fdde1eb16a6d9c89aac2198bb0e6908c39320b8cdbd"
    sha256 cellar: :any,                 ventura:        "454159f8d05415a59f960e28e180a4927dc34d73c021ff51798e395d05945f82"
    sha256 cellar: :any,                 monterey:       "e05233dc2a53492c810030345312dc4e8fdfdf8316254a083e77772253630280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fedc09c6e263f187fe42dfe7d24ef9896e882207ab4a2cd3078bd1befff6a7a"
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
