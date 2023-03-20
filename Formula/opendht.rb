class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.4.12.tar.gz"
  sha256 "5144bc4456d396b527b59065064bbc31fbe0d2af5fd052506219a66895791e64"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a47280a611b43e45ef4a152873b7145aaedb28bb3661cdf962f7e08c2052f5b2"
    sha256 cellar: :any,                 arm64_monterey: "6cc4e29aedfd4c332dee91d2103b614965255bb0281e2d173eaa818071d98ab6"
    sha256 cellar: :any,                 arm64_big_sur:  "d2a57dac11140dbb1460d991357628d0f2447cf18e92d527e38d888dba0c7a88"
    sha256 cellar: :any,                 ventura:        "5444ad9cdabd6893c8a60d364a77d41447049ad6e7f9511879468ac772712b89"
    sha256 cellar: :any,                 monterey:       "d9249fca0593b2ad533abe2e1f3f9d8bd41573511ca58c3aed876291a1ba29f9"
    sha256 cellar: :any,                 big_sur:        "d7abf56c474403862d5c79f36130b15d58c6a3cd04ed8634949b0bad2b7c7862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "841191babfd0c2fc4afeb53f28aeb79d43a1ad92a6658329691bb32b49ffd44b"
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
