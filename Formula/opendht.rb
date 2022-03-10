class Opendht < Formula
  desc "C++14 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/2.3.5.tar.gz"
  sha256 "fd762832ec82094f9b95a21a6ee54b082db2c81a5860dd24cf0599810df8b1a3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "da2867537d1958222ced6a433334f1b1a64d1cecb3f93fdd582c47ac1ea91be9"
    sha256 cellar: :any,                 arm64_big_sur:  "8218db30d61f5bc3333d4fb6b5cc7b07ab9bb8b1715c06ad2b7a2b5a52762a7c"
    sha256 cellar: :any,                 monterey:       "68fddec31a75ad5a9cf38f1cf3d10ba0ec6e72e6cdec81f08be118aeb6519d1c"
    sha256 cellar: :any,                 big_sur:        "4c067c43b6d3c302393d72a61bcef851e24bd35f8186b7ec397c4f7f0aa247a1"
    sha256 cellar: :any,                 catalina:       "b371304a02708d5eb597296706775ad18ed67b361d0e63faa560424553878f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5de124feb505f57d33c081ac42401ee79505714834e10c5934e122ac0e8d85c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end
