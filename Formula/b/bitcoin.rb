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
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a10a6691248cd5f027975b556c34bf89ff25f52cb58f9ddaa8b7d35f5343434"
    sha256 cellar: :any,                 arm64_sequoia: "31e5f2c4ef81f0e20d36b97da2167173d75c8ac1c900e05c5259257569405a02"
    sha256 cellar: :any,                 arm64_sonoma:  "4fe86f4b05bcfc2da2d4944a74773284846a198f5c45aac56b5639d283e502ce"
    sha256 cellar: :any,                 sonoma:        "f91ec03342b37ae58d509a122bf0648cae66152c7ade28e6e21171ace473a0d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56da504153239b2c2c628c9a71a93082eeb39b469cad1dae18ccec1062a5795e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbffe4d9c0485ae80f90c4f72f352011182a1f2db82b57b6949b19dd379b36e3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  depends_on "zeromq"

  uses_from_macos "sqlite"

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
