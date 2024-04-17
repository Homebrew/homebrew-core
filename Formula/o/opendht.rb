class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.1.11.tar.gz"
  sha256 "ab543cc391824fa1a8b1a593f897c26a033352acff889940c009cb63e49b4f93"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "718ac4a69722c4563098f20243907ddcd27f483768f2a1446e57d99ac386e578"
    sha256 cellar: :any,                 arm64_ventura:  "6223ff482bd82b884e99307157f13978ed89a6e42a6cb2e16bb13f750ef3d5c4"
    sha256 cellar: :any,                 arm64_monterey: "4d43112f888697a5dc6497926be9e6a3daca9ffcc882404ff7fcd8aa6b4948df"
    sha256 cellar: :any,                 sonoma:         "49a4cfac2264f803cfc0314b688f7511965af86599d14a48c5256a5857c86933"
    sha256 cellar: :any,                 ventura:        "7d69d4aa4c8414fe57328426a557ed53165dfe5ac69fc43139f7e1eaf519ce8d"
    sha256 cellar: :any,                 monterey:       "5c946bf099b08041a9544f3611708203bed708b17104d825e48b3fe4196aae86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c99edc8ebd6c8622be8c9f2ae1b6a883af40e38295be46ecdc6669091d0b50e9"
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
