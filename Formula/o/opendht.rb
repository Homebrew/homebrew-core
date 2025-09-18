class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "4e8918981bbffa197ffd169fc38b92bf449025182623e353e765e50438d17a26"
  license "GPL-3.0-or-later"
  revision 1

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8a9650c75c5705c119f3196861bee82bcd6f653c5ab524ce29b4a0fee3bb963"
    sha256 cellar: :any,                 arm64_sequoia: "56f5294046b2b8a74fe25b45fbe88caeeffb844463bf9f03424105978f0377e1"
    sha256 cellar: :any,                 arm64_sonoma:  "94f53cc5e5ac2167d8f317085a5a225ae63455e8f81a00ef60ec6643502a48f8"
    sha256 cellar: :any,                 arm64_ventura: "956755cef008d6edbce27a90184fd7b1c9119ea2d1b4fcc9fdfbd95765b4d319"
    sha256 cellar: :any,                 sonoma:        "d4b91618327cb9b0b0721fb72bcaab219431cc7ec777b6b42d3c7726aa4bd1bc"
    sha256 cellar: :any,                 ventura:       "1617ad5bdf8a7a0d544a173b3e22173c64975aecb77603af6cc58a55be99686c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb862fc675efc1e1aadf5083df9595f1ebbdccc37449c5941829bb41b42c4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3206f56fd45047012102280311d8c51f100ee5e8d1270b935a26c3a81b9dbe"
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
