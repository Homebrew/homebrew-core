class Nuraft < Formula
  desc "C++ implementation of Raft core logic as a replication library"
  homepage "https://github.com/eBay/NuRaft"
  url "https://github.com/eBay/NuRaft/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "073c3b321efec9ce6b2bc487c283e493a1b2dd41082c5e9ac0b8f00f9b73832d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ea3f306e6ff8caed8af6766269952ba484a9c93616bd3022536ecdf594244293"
    sha256 arm64_sequoia: "d8c11cb1794414a156702a0dd8e2e4c2f1364b3ce70d72fe0621ec8ee38e3153"
    sha256 arm64_sonoma:  "12ba02a1696da77e500b797871ae74e95faef90716c9926226a89eb27bccc1b9"
    sha256 sonoma:        "6448d43767ede630932d6bdb91a5d898fa1009c2fe50ef151c39c02d9d1b6c01"
    sha256 arm64_linux:   "fc1791ce60a81c886fe5c3484636b8ef7645eb8fa08d7d4a0f1d7ab65d40b277"
    sha256 x86_64_linux:  "922ce348211e72adc865d2a6976cd7a2b914d1ea88c4508fb80fd7430cac185a"
  end

  depends_on "cmake" => :build

  depends_on "asio"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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
