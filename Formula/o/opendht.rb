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
    sha256 cellar: :any,                 arm64_sonoma:   "5a31ae7cd4370eef59b51b61f33c9d242e2b9b75393f1a499fb9e23b1a2ff5fd"
    sha256 cellar: :any,                 arm64_ventura:  "5a80cfeebec9ed84ed9b1a6ea27faf70a223961c48f6c11dd47f01562ae08810"
    sha256 cellar: :any,                 arm64_monterey: "387556873417e9e340b6a6a269e3c4841ce0a50d7d0e1477430a90562d64c788"
    sha256 cellar: :any,                 sonoma:         "107c4f1420d18c4636965c3445c36ad29f0fcb7c3540bf246774de812040144e"
    sha256 cellar: :any,                 ventura:        "92e9c194f9e57de853e2419382391732997cc01021dee94d197d24a6c6d4ad53"
    sha256 cellar: :any,                 monterey:       "db1623bea5b24536eeb3da9751bce6d7826db7241b81d6af33e62aff8c4b067b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de4c11d17872baefc4b45ee6795f1f2ea320a835d346d66dc1e7e866d5e0f96d"
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
