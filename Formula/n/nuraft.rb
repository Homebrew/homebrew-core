class Nuraft < Formula
  desc "C++ implementation of Raft core logic as a replication library"
  homepage "https://github.com/eBay/NuRaft"
  url "https://github.com/eBay/NuRaft/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "073c3b321efec9ce6b2bc487c283e493a1b2dd41082c5e9ac0b8f00f9b73832d"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "57d924190590cdb01bcd5f62264e6c3af26192ba7e0025f31ec48f562caeb5db"
    sha256 arm64_sequoia: "9f0444da2009a60f4b82f977cfb9bc52d968b0e5137e8b71e5fbf916af77475e"
    sha256 arm64_sonoma:  "ef01fe0ef80d4cb4b0d71f75852eb31bf371a6467145826a0c22cc6b725e4454"
    sha256 arm64_ventura: "a0a521444542143814cbfea45bbbe56fa663df2bf4ec6e38f9b90b109176f813"
    sha256 sonoma:        "a4e7e1636198eb052538eadd905e38f7ad41698b8e161204d515e8580159651d"
    sha256 ventura:       "9a0710600badd9d65b2b3848fb8d3817acd5f1f491202c19a27f3d8b367d2e63"
    sha256 arm64_linux:   "3de18ac7749440d6cc2207d0930aae4bc8ccbb7654cf871181136398caa669f2"
    sha256 x86_64_linux:  "5b8e3ed8205c1c74edb71ad5a819fe84c27c03c51538c5bc6eb4174ebe87398b"
  end

  depends_on "cmake" => :build

  depends_on "asio"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
