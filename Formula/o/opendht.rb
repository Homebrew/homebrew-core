class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "ce93396fc7aa118a69353ba75c6615dbea965d7d8607f55a50bb442bd21bed2e"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d47bd78265faeeb87d774862c13a4befad2ee1fb96661f0e95225a71d670558"
    sha256 cellar: :any,                 arm64_sonoma:  "42c6d746788177da5b3fcd1e39446a9c51216b6d0700fec73f47ec84e77cba16"
    sha256 cellar: :any,                 arm64_ventura: "25d3b25e42a10d6cb47ca10435c2909af91b7bb36dea3f60cbc1f0c9e77b75f9"
    sha256 cellar: :any,                 sonoma:        "99e170ce8ee9fd0fa1f9ce55106f1064ade38216a8a76626288ee3fd03460fe9"
    sha256 cellar: :any,                 ventura:       "6904b5cdd9c7d40dca0859380069c93e87912f61d75c3d3f9944f14d48d2efe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f7238bbff2cad047c70d520eed1cac148849f70fe451fab0553a7e788a33cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed9c7d62405933255495e87727695f89913563975962f8b652dd3c4347f50d4"
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
