class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.4.9.tar.gz"
  sha256 "ede4a0adee7e5d98d9681cfd2bab83421b153afcdb5efa1a925986a0a3a0ac8a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "541dae8ea7a93cfccb8edeb075787995e63e370c9d7236152c9d2bc53877cebc"
    sha256 cellar: :any,                 arm64_big_sur:  "78a224ae7d2c820bd91867bbeed21929acd619fb41101c2f81d4fd26d2fba027"
    sha256 cellar: :any,                 monterey:       "34b51b2ef9c164b3230d0e8cdd1a0d215d33a7bffc626adb1f5c13024228c432"
    sha256 cellar: :any,                 big_sur:        "de4b832292a32dcc269bb0d69f1cef07ae361bb2482ff1ad44ea8b7dd797d607"
    sha256 cellar: :any,                 catalina:       "d05544444c4492dfc8ad26496a15deadb8b45fe9f52ab901193edfd75fc8d1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0880486fd4139f3dc453a6bc1218bc5bb7f62a0a780099477603c3c3d8d6813c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
  depends_on "nettle"
  depends_on "readline"

  on_linux do
    depends_on "gcc"
  end

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
