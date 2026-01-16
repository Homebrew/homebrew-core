class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-30.2/bitcoin-30.2.tar.gz"
  sha256 "6fd00b8c42883d5c963901ad4109a35be1e5ec5c2dc763018c166c21a06c84cb"
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
    sha256 cellar: :any,                 arm64_tahoe:   "5c0409619840c651a880ec360e992e0b68f0d27cb3105113eec42b698ac288e5"
    sha256 cellar: :any,                 arm64_sequoia: "dfb8eff303ad4b182f37cee99e00ed53231b4f7fc680b7f61c47ba65e1ae3ab4"
    sha256 cellar: :any,                 arm64_sonoma:  "9c6484cc655800889089b1b842fe0e56289365376ea594c8f3bd8e1670b3fb43"
    sha256 cellar: :any,                 sonoma:        "409e8f2be7d2774ebab20eadc7023b8e38259629739e00f85d60a7047df17ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2228d4aaaeee7a30d6886f6eb344b6f50fad4d45a2ffec3a82fef2daa12d45c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa01580f9ecf9f7c7b7fdb14bfc4965a87dc83b54bb7ae45324d5999176feefb"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_ventura do
    # For C++20 (Ventura seems to be missing the `source_location` header).
    depends_on "llvm" => :build
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++ 20"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.llvm_clang if OS.mac? && MacOS.version == :ventura
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
