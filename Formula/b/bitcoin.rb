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
  revision 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25eb3100de0efdbbc3673d8afe07e2a32df3f68847ad4d5ff10ae2b4f8c22bb8"
    sha256 cellar: :any, arm64_sequoia: "a57d478221b6de21b5a9cc5a62b8ea882a958b2bd0b376a15b295be57932dbb5"
    sha256 cellar: :any, arm64_sonoma:  "5024963b269d7f21ec6a7125f7d1fbfdce5d24324c9e8e8b8f4a416a3c59b607"
    sha256 cellar: :any, sonoma:        "71329ebc26775ff50a12240dd5fc0aa20c783eeeadd9a61c27d73866ad857d76"
    sha256 cellar: :any, arm64_linux:   "097b870be991319fdbf343795723c47bdb67c70c9301652b84d52caf78599815"
    sha256 cellar: :any, x86_64_linux:  "827c1ae0789963fd003a4287b1f19ae161b4872275e712f0520e1fd2211751db"
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
