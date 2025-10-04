class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "674249c4ac07c4392566d761c0189c7bb11dd7b17e9a331c69d6881f7d01e043"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce4841328fea1b93a3c92f0f858269f83a382aae08fb196dd0483f3e5aca89f4"
    sha256 cellar: :any,                 arm64_sequoia: "4bed40d3daa05a1e2976d116de40e8115deee46608bbad278a71eca318be2e4d"
    sha256 cellar: :any,                 arm64_sonoma:  "1edc8f170c4eb5ef039e629830fcdeabe097845332612c706aa31a8445974754"
    sha256 cellar: :any,                 sonoma:        "97b956a17aa9f6f4a148181dfd52229b80982934eaddd9a79e08dd36e91c6c32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9645357d5f981b527bec8eab40e7e58f2f51f42a62c27b1d85227a9d772ecd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b872f54f996e20e1007f2749495a16faea1424777fc8c30a71becdecb24d6b72"
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
