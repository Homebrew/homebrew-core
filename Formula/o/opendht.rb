class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "019564087f0752a1c09347473c39b2d48e920247f25f68dac235f1e5d6204ea4"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94dd6980c8fe6d530989f502a8e1649c2f49fd8420296d55c482dafaeb715222"
    sha256 cellar: :any,                 arm64_ventura:  "f42fd79d9b7612d66e06b7a5b74171661c447d3e1bf84ae35783db24ff78e136"
    sha256 cellar: :any,                 arm64_monterey: "259069c88da0b62a4db12f48142779a4a194256b7abe0e7b6100dfed953eb88a"
    sha256 cellar: :any,                 sonoma:         "0877e81bf7823a9fb7185b984871167d97ef2025f2a6b383fda37a782c6eea17"
    sha256 cellar: :any,                 ventura:        "14812f8b82f1f91c029a185b1060deac00cfd8b091fe35096a85a668f9574793"
    sha256 cellar: :any,                 monterey:       "965b1f10abf2db561c715fa015249bd9ba1eecdf7e6b6db17964df1435ca862e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5da6ac3404bbc995460396ba4cb7db26e1753a7dec0a7a822d378e89f6766f61"
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
