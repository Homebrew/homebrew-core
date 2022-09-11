class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.4.10.tar.gz"
  sha256 "8077958fb7006612b9b9758095461d8a35316b4224184f10cef785f0ec7031fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6776bebfc0223942a562a535d85ac24f62c861d8f549614a3b3ce103d43f9c20"
    sha256 cellar: :any,                 arm64_big_sur:  "8f8ee8e9ad493ae8d2ec6d87dc03fc0dab162f8903a012d546980147dad1ba2b"
    sha256 cellar: :any,                 monterey:       "52e6f836a6eeedf3e6fe78a9caf6561e0f2714b947936cdfbc5ababf5763e292"
    sha256 cellar: :any,                 big_sur:        "f30dd9119c62a43f18db1f45a750c727f1fa566bfa1a3b336c7807bdd2df5de9"
    sha256 cellar: :any,                 catalina:       "f043dbf03eae2455f2dad7b8dfd41cc7a99509e87c8d53eca4de6e11fd123296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e97e14bb9d30e1184c2bbbd7d309ba985b55bee56d6b96ebe67833f0fa1786"
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
