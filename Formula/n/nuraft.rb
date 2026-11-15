class Nuraft < Formula
  desc "C++ implementation of Raft core logic as a replication library"
  homepage "https://github.com/eBay/NuRaft"
  url "https://github.com/eBay/NuRaft/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "073c3b321efec9ce6b2bc487c283e493a1b2dd41082c5e9ac0b8f00f9b73832d"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "517e0a885621767c861246519db093fe346ab22726f7ea48401944b11c040890"
    sha256 cellar: :any, arm64_tahoe:       "3fe144bec835ae99558360ce66dba39bf6d3c4ca19e38c66a579e14927e11418"
    sha256 cellar: :any, arm64_sequoia:     "31b701afa908f0ab05f611ce43f4fc12dd462ad5284ca17a00a70c4e0c11b76c"
    sha256 cellar: :any, arm64_linux:       "21045bf1bb5ccfab056b036173702c56190f4113ba09a0f84b84012a1c64aa27"
    sha256 cellar: :any, x86_64_linux:      "cb7bb5d88c1a3bbba642b274b827b8b966dd5184e05321fc6d68e12d27c0780c"
  end

  depends_on "cmake" => :build

  depends_on "asio"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    # Avoid statically linking to OpenSSL
    inreplace "CMakeLists.txt", "set(OPENSSL_USE_STATIC_LIBS TRUE)", ""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cxx, "-std=c++11", "-o", "test",
                    "quick_start.cxx", "logger.cc", "in_memory_log_store.cxx",
                    "-I#{include}/libnuraft", "-I#{testpath}/echo",
                    "-I#{formula_opt_include("openssl@4")}",
                    "-L#{lib}", "-lnuraft",
                    "-L#{formula_opt_lib("openssl@4")}", "-lcrypto", "-lssl"
    assert_match "hello world", shell_output("./test")
  end
end
