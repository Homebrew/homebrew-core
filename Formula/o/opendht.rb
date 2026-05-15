class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "363bbe80e937e612c6642e0a395a9efbc0714dfeb65935ec6a63194a55ca8aec"
  license "MIT"
  revision 1

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4780c887120eb5982b7c56d8dffcf9c379742bd6d29651a45b498b1add0b1174"
    sha256 cellar: :any,                 arm64_sequoia: "cecf455aa1a7ca788fd7aa93f61991306892eac5d4f7068262679b8913ca39e1"
    sha256 cellar: :any,                 arm64_sonoma:  "fc85fed2611c68a15f6b415c56a4e04d0437d041cabae939c1be94d4e97b8fea"
    sha256 cellar: :any,                 sonoma:        "594ebd908f73bd3f1c27e8c2c165a59065960adc8683af28b3f442122d956cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "950bd7aad0db1887175b147b1675c515932fa61a33460813d7af3ebf0c0a07a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f7e95aebe4cee7fec6609edb149c5728cdeaa41936ae365fc4a2277e0cc3f2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "asio" => :no_linkage
  depends_on "fmt"
  depends_on "gnutls"
  depends_on "msgpack-cxx" => :no_linkage
  depends_on "nettle"
  depends_on "readline"

  # Apply Arch Linux patch to support Nettle 4
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/opendht/-/raw/f9240e64a01cdadc5c8401e3a1106ed7cd9bf3ee/nettle-4.patch"
    sha256 "88556b2a0cf071971a565ea312be9164356747656078d3537d3910bc38af8880"
  end

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
    (testpath/"test.cpp").write <<~CPP
      #include <opendht.h>
      int main() {
        dht::DhtRunner node;

        // Launch a dht node on a new thread, using a
        // generated RSA key pair, and listen on port 4222.
        node.run(4222, dht::crypto::generateIdentity(), true);
        node.join();

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end
