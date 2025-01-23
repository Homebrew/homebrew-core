class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-28.1/bitcoin-28.1.tar.gz"
  sha256 "c5ae2dd041c7f9d9b7c722490ba5a9d624f7e9a089c67090615e1ba4ad0883ba"
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
    sha256 cellar: :any,                 arm64_sequoia: "3b8dd7b2f87fdd035a1a43fb33d815ca5d1b579051f39be65abdea52207787e4"
    sha256 cellar: :any,                 arm64_sonoma:  "a194275ef4a83ec4ba833598c7e5ae6b90aaee12e3e48141563d4d5c3db58f7c"
    sha256 cellar: :any,                 arm64_ventura: "6b7ae606988258139e4b8d97d662758d10c4c93c34cc3d05242f274c971cd387"
    sha256 cellar: :any,                 sonoma:        "448277b6d5eea93cf8fed2417f752034f720b851cb5eae337863646af75bd78b"
    sha256 cellar: :any,                 ventura:       "3f3dd8b5c72068db2277535f3c449a9338a2079b398376aeebc3963ba78c6f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5bf3062a9b43ad8e522cf102e21496973249ca5dedada6620e659bec5dc1ae5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on macos: :big_sur
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

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
        # BerkeleyDB requires you to build everything from the build_unix subdirectory
        cd "build_unix" do
          system "../dist/configure", "--disable-replication",
                                      "--disable-shared",
                                      "--enable-cxx",
                                      *std_configure_args(prefix: buildpath/"bdb")
          system "make", "libdb_cxx-4.8.a", "libdb-4.8.a"
          system "make", "install_lib", "install_include"
        end
      end
    end

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "BDB_LIBS=-L#{buildpath}/bdb/lib -ldb_cxx-4.8",
                          "BDB_CFLAGS=-I#{buildpath}/bdb/include",
                          *std_configure_args
    system "make", "install"
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
