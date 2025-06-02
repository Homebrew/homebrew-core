class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "965732ac3c2bce767bb543b8b033c29979ef5357c9a0003e3631dcb15f5a457c"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0fce58b69f3a0256353e9e94263d95e85d3f3c6c631df43cbfb065550094d4c"
    sha256 cellar: :any,                 arm64_sonoma:  "1ac4353285336d77796d28f3fab3e2aad82c37c3e8da551c40f4dad3b07fb9a8"
    sha256 cellar: :any,                 arm64_ventura: "5d65f6e8b450895d7fc89531962e4bd3a1f2acaa4330805940f007ecbd9a6679"
    sha256 cellar: :any,                 sonoma:        "5c5ba2014078ed164d48c5f5bedc3f4ea3bc9a47e0805367e70d596fe46ea9af"
    sha256 cellar: :any,                 ventura:       "d39b5e11f01b22c79084670b3e8cb8d30e6a5b28678cdca61bd9eb91b908b40b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3837910fb890af95200347d60d6f0065cbe75de4f5aeec8ad4756ee0bcba5ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beae52025cdd96c5eea51ca72fafc5a1b2e2772739c246523e4381c288d7358c"
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
