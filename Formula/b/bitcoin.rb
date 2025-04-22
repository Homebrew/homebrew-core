class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-29.0/bitcoin-29.0.tar.gz"
  sha256 "882c782c34a3bf2eacd1fae5cdc58b35b869883512f197f7d6dc8f195decfdaa"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/crc32c, src/leveldb
    "BSL-1.0", # src/tinyformat.h
    "Sleepycat", # resource("bdb")
  ]
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8fa8fcf7ccb91a577436dcacdc6ff4140b960518466de5c6086788c5b705e737"
    sha256 cellar: :any, arm64_sonoma:  "dc06414451b6958961bbb761c30596111a1108b90553990b2c23e4583c59cced"
    sha256 cellar: :any, arm64_ventura: "b44e261cc593181a6d7911747ceb9fcac26ef45e2c464539133291032226a050"
    sha256 cellar: :any, sonoma:        "060611cfbfba123b4c61cb4622d292ba56995184581a466d7967eb6263dce0c3"
    sha256 cellar: :any, ventura:       "4ad32aea3bf5f4f2f0cab5e1d25a2a6ae8e7cdec9322fa8f3942f0968cd2bfa8"
    sha256               arm64_linux:   "70752d59e92fe46e0942521e9d05c02ae73e0003258c7ec0da481e30fd8a6c09"
    sha256               x86_64_linux:  "a1dfba272b3381616eec1ea655b2cf320070b48985272517fb36277917188efe"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on macos: :big_sur
  depends_on "zeromq"

  uses_from_macos "sqlite"

  fails_with :gcc do
    version "10"
    cause "Requires C++ 20"
  end

  # berkeley db should be kept at version 4
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
  resource "bdb" do
    url "https://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz"
    sha256 "12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef"

    # Fix build with recent clang
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/4c55b1/berkeley-db%404/clang.diff"
      sha256 "86111b0965762f2c2611b302e4a95ac8df46ad24925bbb95a1961542a1542e40"
    end
    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
      directory "dist"
    end
  end

  # Skip two tests that currently fail in the brew CI
  patch do
    url "https://github.com/fanquake/bitcoin/commit/9b03fb7603709395faaf0fac409465660bbd7d81.patch?full_index=1"
    sha256 "1d56308672024260e127fbb77f630b54a0509c145e397ff708956188c96bbfb3"
  end

  def install
    # https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#berkeley-db
    # https://github.com/bitcoin/bitcoin/blob/master/depends/packages/bdb.mk
    resource("bdb").stage do
      with_env(CFLAGS: ENV.cflags) do
        # Fix compile with newer Clang
        ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200
        # Fix linking with static libdb
        ENV.append "CFLAGS", "-fPIC" if OS.linux?

        args = ["--disable-replication", "--disable-shared", "--enable-cxx"]
        args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

        # BerkeleyDB requires you to build everything from the build_unix subdirectory
        cd "build_unix" do
          system "../dist/configure", *args, *std_configure_args(prefix: buildpath/"bdb")
          system "make", "libdb_cxx-4.8.a", "libdb-4.8.a"
          system "make", "install_lib", "install_include"
        end
      end
    end

    ENV.runtime_cpu_detection
    args = %W[
      -DWITH_BDB=ON
      -DBerkeleyDB_INCLUDE_DIR:PATH=#{buildpath}/bdb/include
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
    system bin/"test_bitcoin"

    # Test that we're using the right version of `berkeley-db`.
    port = free_port
    bitcoind = spawn bin/"bitcoind", "-regtest", "-rpcport=#{port}", "-listen=0", "-datadir=#{testpath}",
                                     "-deprecatedrpc=create_bdb"
    sleep 15
    # This command will fail if we have too new a version.
    system bin/"bitcoin-cli", "-regtest", "-datadir=#{testpath}", "-rpcport=#{port}",
                              "createwallet", "test-wallet", "false", "false", "", "false", "false"
  ensure
    Process.kill "TERM", bitcoind
  end
end
