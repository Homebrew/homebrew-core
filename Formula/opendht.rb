class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.4.9.tar.gz"
  sha256 "ede4a0adee7e5d98d9681cfd2bab83421b153afcdb5efa1a925986a0a3a0ac8a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ba6afbda65d997c3f004458a389914f8c0a234c6be7c63d41a3f51e8c2131ee"
    sha256 cellar: :any,                 arm64_big_sur:  "a188008563e0a870af82a6d370677d6b107ae5211ae654b8d5a82b53d73412b8"
    sha256 cellar: :any,                 monterey:       "814bf1c3a78e20dfc8593dd866b79150b3c711e5222230f0e548ad6a0eded82d"
    sha256 cellar: :any,                 big_sur:        "6331127bf6e9cb65aeb03fa13238eda92df1a32d74e8ae5aab25a0691466d618"
    sha256 cellar: :any,                 catalina:       "2eb5822ae7d836d5cd14d670371977e34204c64ed2d3de32611e939cab09b986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65dff89ecf6bc347fc9c43f1a95d193eee9744a24d07e4fa2a1ee65b5ea42c97"
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
