class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "1405dc110af85375c205f711e03e231b82d1737040814f1318f3bb2bfa63d8f8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4750d21f1e46f87f3374812f3b9fea6804a5060b5d8ab3c2ce0624dd472a3a26"
    sha256 cellar: :any,                 arm64_ventura:  "3b4b7ad45085e3b510a46e26d8f2086b0cbec19bb21244fe4ebc92419d0269e2"
    sha256 cellar: :any,                 arm64_monterey: "2c36c8601453b589583dc9749e6184a7e6eb60359dc2a6ce10d7c2ef157c1c98"
    sha256 cellar: :any,                 arm64_big_sur:  "26d4c68ed334c7e118a0b92a886a2526b38a231a83c223d2c369d0bd5edcc97d"
    sha256 cellar: :any,                 sonoma:         "812bad73f038625715ed45791c91bd5368ffc2e175c87c5d2cc5a26239a22951"
    sha256 cellar: :any,                 ventura:        "c029e89706e8ea1b9695d90579f93e84f2b42ed3965b26287a1d3337ddd60ee1"
    sha256 cellar: :any,                 monterey:       "dfbb8d2fb0e85dc154089b727702b5cad9fd1f6170e9dd95f504755c4cf31c18"
    sha256 cellar: :any,                 big_sur:        "c297e770b7760b2ff8f6999b7a9fb2fa1de3068647a1f68645300ad10ff17e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca0c68aacbb601bbbfc1c4a8a6dc1d183ebdb65f54dbbbd94cc1ca99e756c28"
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
