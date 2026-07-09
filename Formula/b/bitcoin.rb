class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-31.1/bitcoin-31.1.tar.gz"
  sha256 "50411d5b43c7e4c90099394759eb6c2add6e7c2dbe728840893d638b6fc6afc9"
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
    sha256 cellar: :any, arm64_tahoe:   "544325cd312a73fc840f31ac725afa7b8053cf17d6a231883b54ded36e872ed5"
    sha256 cellar: :any, arm64_sequoia: "9462c51351dc6f2d26c2a8fc0f683d6039baa8681c403c890a856e8779e9fbe9"
    sha256 cellar: :any, arm64_sonoma:  "358b97732802f0330d57910560796bbe001421f024f06e798830d4aa27c2df62"
    sha256 cellar: :any, sonoma:        "49699e58ea89e232959029460e46cff9bb2dac62e81457818403cc68ed2a5638"
    sha256 cellar: :any, arm64_linux:   "b225270b5d135f55463a27c1983d125b7e5c8eead1d1d38081ea33d980001e37"
    sha256 cellar: :any, x86_64_linux:  "8f968276ae2d960c757bae0956349966041a6a33e279b08f6e51290ec8564bf3"
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
