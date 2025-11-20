class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-30.0/bitcoin-30.0.tar.gz"
  sha256 "9b472a4d51dfed9aa9d0ded2cb8c7bcb9267f8439a23a98f36eb509c1a5e6974"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b41df41b0bdf46fe7877a738e33eaaf0eabc97361eb3b759e2712e1ec93a23a7"
    sha256 cellar: :any,                 arm64_sequoia: "7174a1ba2ff1ed54708af13bb36f27424c37cae053c8dfda0ac19d0ac1d2671b"
    sha256 cellar: :any,                 arm64_sonoma:  "672a522db69b84fa3c9d1111e3cbbfe4b780ab915c449b8a67f6f142503eff8b"
    sha256 cellar: :any,                 sonoma:        "353356a2b200c3ef5e1c3727a11cd8ac86058673c157758e9aa3fee027146fca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4203d3296dae07be3e8d6ffe961e77faf4b1e76a59de729b7929c87c51c428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae10c54ebb004117d6b3ab91f62fb6b6dc6e3ed9c6953686a79a20a3de340b60"
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
