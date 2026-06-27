class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-31.0/bitcoin-31.0.tar.gz"
  sha256 "0ba0ef5eea3aefd96cc1774be274c3d594812cfac0988809d706738bb067b3e3"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/crc32c, src/leveldb
    "BSL-1.0", # src/tinyformat.h
  ]
  revision 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ab247a55851a7722c335d480a4981d06faf29ca60ae8027911be71b6ed91948"
    sha256 cellar: :any,                 arm64_sequoia: "b7022fa13275e49e74dbba57fca956d26ec158edc97d47f8c1914ec686537bfa"
    sha256 cellar: :any,                 arm64_sonoma:  "8a25f7b508590b98f885591485702369c8f21f3b41e6c1c1f792ca5c83ddc5bd"
    sha256 cellar: :any,                 sonoma:        "29f6ee5ffdb64ab5690d4a0e12db15cef5538cc4f9b9ce528f7a08ece12221ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c22ee4cbd61b46cc2bc926ed8f152f8f5d472dc895a66d7854118f01e58afa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6761039b6f88ec3587c9c9befd2a10c168c4e21b824632ed5583ce94dfe7053f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_macos do
    depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++ 20"
  end

  def install
    ENV.runtime_cpu_detection
    args = %w[
      -DWITH_ZMQ=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"bitcoind"
  end

  test do
    system bin/"bitcoin", "test"
  end
end
