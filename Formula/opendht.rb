class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/2.4.3.tar.gz"
  sha256 "ed7f1a6714c4cf0afc79a736b6f2c91545aaebda1f2f91357fa0e79d2fb97d60"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7dabc73c643cb66bb5c10264216acd346fd2dc73400b54a5e7e5334483981a05"
    sha256 cellar: :any,                 arm64_big_sur:  "56610b9952fef8031f9c13e868c8e630fdacea01e300aa9113ffec92a8d1fcf1"
    sha256 cellar: :any,                 monterey:       "edb40db3e6c3a54b3f3e224880b409b0e17da7b1c9a4a23706912d06ae0a1c22"
    sha256 cellar: :any,                 big_sur:        "1547259e336a0c55ac4000ccd462afc66f9c6255dfc100f1461f6aeb1ad55c6a"
    sha256 cellar: :any,                 catalina:       "0ca0cdce79dda6ed1b98f184efc7f3bdde63d3507a7574c075a07a393f4579e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63553c7fc05cb84f229073a54f124138c5deec54c38f870c9e9eca6eab048e75"
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
