class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/2.4.7.2.tar.gz"
  sha256 "3e8eb91622ac73ca080159e6ec04192ec0c948fcea493db3dd84cda1443c2577"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e34083a9ec000dbff54479bd0192eeefe2333ddd01a62f3c41f10358849dda67"
    sha256 cellar: :any,                 arm64_big_sur:  "2eac71d26349d153bc1ad87ecb6b53ad5fda9862354ce5911224c4ebf7821ff8"
    sha256 cellar: :any,                 monterey:       "e140101faecd2f7bb613b70a6e6a90edb1385a1251aeeac7ae124483e43c2f0c"
    sha256 cellar: :any,                 big_sur:        "433afce34ccdc0d724bb68dd603d935b37d9fbb66816a139a75caf7810535a0c"
    sha256 cellar: :any,                 catalina:       "92a11068209013402ce0e6bd5fbcd7018969b770c934394e429c14069d211e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54171f0d36426aefd94acc3bda2cb27922cf0af59ec10c84160cc779c4b87d8"
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
