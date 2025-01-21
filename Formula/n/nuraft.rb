class Nuraft < Formula
  desc "C++ implementation of Raft core logic as a replication library"
  homepage "https://github.com/eBay/NuRaft"
  url "https://github.com/eBay/NuRaft/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "42d19682149cf24ae12de0dabf70d7ad7e71e49fbfa61d565e9b46e2b3cd517f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ed4e1168c59ea1e986ca986e299b85258d59b8b3d7b3cfdbb05894f3f7d0d9cc"
    sha256 cellar: :any,                 arm64_sonoma:   "c920e4db840519a912a09fdc910ea3460c629d7b86094117cef833a921789b48"
    sha256 cellar: :any,                 arm64_ventura:  "17cdd2860bbcd32bfa028c1706c02da066a796b0f1abfca96c76bdbcb05ca012"
    sha256 cellar: :any,                 arm64_monterey: "5d024f15a5a6644bb74b7293ab5939376e9115102c3dcf466d9ef209496a27c4"
    sha256 cellar: :any,                 arm64_big_sur:  "46efae0c6123d49ce9cf3f9f4798b4a556bf55e1cf7fbb1aaa12ce6b458613b8"
    sha256 cellar: :any,                 sonoma:         "40cbb00d86e4ae30fd5f3c351f05339e8b0f0f70f8c579e346113853126c0d17"
    sha256 cellar: :any,                 ventura:        "e38d6cbd1be543fc3ee42ce4573309c0f058c83d8151519f9ce9272c4edd82f3"
    sha256 cellar: :any,                 monterey:       "81250cae0a2c2ef68e88b1ab3e0f394d6ad803f257e23cac33ce07c7f4bfbe93"
    sha256 cellar: :any,                 big_sur:        "668d54563b382c1160246452e6cf54fd6832c238e33731613d6537418f474b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72a6fa91392aacbbc97f42a17330a2bc0c4b38dc97c3477f87b6c9c90474bd28"
  end

  depends_on "cmake" => :build
  depends_on "asio"
  depends_on "openssl@3"

  # patch to include missing header, `event_awaiter.h`, remove when it is available
  patch do
    url "https://github.com/eBay/NuRaft/commit/65736ff4314a0fa15f724a213fa42bf26bc86f70.patch?full_index=1"
    sha256 "0d06d4a6b5b6fa348affacfff6bc100df1403a7194d7caf2b205e8a142401863"
  end

  def install
    # We override OPENSSL_LIBRARY_PATH to avoid statically linking to OpenSSL
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DOPENSSL_LIBRARY_PATH="
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cxx, "-std=c++11", "-o", "test",
                    "quick_start.cxx", "logger.cc", "in_memory_log_store.cxx",
                    "-I#{include}/libnuraft", "-I#{testpath}/echo",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lnuraft",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "hello world", shell_output("./test")
  end
end
