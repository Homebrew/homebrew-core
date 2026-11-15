class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-32.1/bitcoin-32.1.tar.gz"
  sha256 "a5f2f61e32cf7f790641c9ec306a3c88ca7b5a556946956b1f35ffd7e27813f9"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/crc32c, src/leveldb
    "BSL-1.0", # src/tinyformat.h
  ]
  compatibility_version 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e9502cc4440192d61a49fabd022dd68c4e5bad09f87e72d24e73f2b0d20d7530"
    sha256 cellar: :any, arm64_tahoe:       "41844a3bed604c3502bd3f06c7a2b60ce02b73384505724dc045c6fe449e7f8a"
    sha256 cellar: :any, arm64_sequoia:     "2bfe12dbe4fd5ce393b0cbad559ed32f58384ca55969ebfb332209c8d74b94ca"
    sha256 cellar: :any, arm64_linux:       "0c4663dd2158cad1916999fecca55a27d4fe96a9dc37441fd5cf479f80806335"
    sha256 cellar: :any, x86_64_linux:      "e15c6221e2a3b65af4f0aa55ab8825ce14480e5364ec65157ded6cc9972e9b43"
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

  deny_network_access!

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
    ENV["TMPDIR"] = testpath

    # sock_tests bind TCP sockets on loopback, which the network sandbox denies
    system bin/"bitcoin", "test", "--run_test=!sock_tests"
  end
end
