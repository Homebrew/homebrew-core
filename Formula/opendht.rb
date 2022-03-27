class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/2.4.0.tar.gz"
  sha256 "4ecc41014add4f9165163072fff2fe72e4f4dd542b799c5baf181ec69c858942"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e52c964ad81c338f401e4b291406c1fe2ce63340661294f10acff61612eb2b50"
    sha256 cellar: :any,                 arm64_big_sur:  "a291ba71d6ae75df8efee0d05e35a78b8ff6e6712afc2c74dc1ffd76b1a111a9"
    sha256 cellar: :any,                 monterey:       "d2bf5a2d95dc4a210e0e836fe5b4da21c9843f6921b6d106fca9e7e4451706c4"
    sha256 cellar: :any,                 big_sur:        "7d82f3e24cde6aad0a834a1c3830eee8c32746d1d812f74414615ff1fa31835b"
    sha256 cellar: :any,                 catalina:       "441ac4e81dc49438410de99af317fe1ac93190af9f5f366ec0c656804287f3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0628e6a79543d5f554910a7669f911e9503d308a17dc025209feb1e2e733415"
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
