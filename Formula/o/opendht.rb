class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "363bbe80e937e612c6642e0a395a9efbc0714dfeb65935ec6a63194a55ca8aec"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0fc3ce493601f30db6e3a6a15c7b56cbfa0d90f911e4c0b3d4d33cd80a1b5323"
    sha256 cellar: :any,                 arm64_sequoia: "6b3ac403c5d69df2aa6353ce7460dcacab6262a1378a3ac90bb549d791449c5f"
    sha256 cellar: :any,                 arm64_sonoma:  "d6abe4cf6538c04ef0924ef51396c33ebce1cdc824dff800ee3a2e4492a56900"
    sha256 cellar: :any,                 sonoma:        "bac677e8a34fd7f609412a32724e7ea59c985845c9d4b1931f5ece1e2e771ff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29bbab9a704134cafded477704180ef11f4f983f8f56974b97a50d2c8481e510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b65244d50d8ff23e65173fd246c0e93006543f19b888c16245924b87a126aeb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "fmt"
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
