class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "019564087f0752a1c09347473c39b2d48e920247f25f68dac235f1e5d6204ea4"
  license "GPL-3.0-or-later"
  revision 1

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8c2a46f19b541b31c73232a5fe3752e4bca862a8625a2ca5aefb7a859cce4630"
    sha256 cellar: :any,                 arm64_sonoma:   "9bb8363e25cc6efeef154b948eb5180fc2b27897e6c3c1dce8d7d5859f6915f9"
    sha256 cellar: :any,                 arm64_ventura:  "62f6e816b14e1ab609ffd09c0c7d3ddddf272b3d959043b70df469dc502f63f8"
    sha256 cellar: :any,                 arm64_monterey: "c1ec403407f12c875eea31227be54d39fe01bee32f9a63ce82d81487bc342b42"
    sha256 cellar: :any,                 sonoma:         "21ec7e6bbed004aa0b93e91449de67cc200e9bf0e18497e54432ff1f892e5574"
    sha256 cellar: :any,                 ventura:        "c4256ffe8b296d1b5a895066994ee7b2f552b898c6f89a61fa2df615cebbff47"
    sha256 cellar: :any,                 monterey:       "a7e9b341adbf6bc5666409ad11de5cab83ef0cbc60231b694d7ab518a3c22acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac478380e718e9891e1f412497ac42960d879fae556ea1e17e3604f464f7362d"
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
