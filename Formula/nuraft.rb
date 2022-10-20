class Nuraft < Formula
  desc "C++ implementation of Raft core logic as a replication library"
  homepage "https://github.com/eBay/NuRaft"
  url "https://github.com/eBay/NuRaft/archive/v1.3.0.tar.gz"
  sha256 "e09b53553678ddf8fa4823c461fe303e7631d30da0d45f63f90e7652b7e440bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "581b6146b83a3f1c1fa53c4e64187ce90142636dba251d2770e91cb43aaa9f80"
    sha256 cellar: :any,                 arm64_big_sur:  "c307cd8c272642f5f8dc53d457771d85346b43b3ebc01e115e74fd1ef5688ca4"
    sha256 cellar: :any,                 monterey:       "2c1372a263af78e2eb8a9a45866f439730e501691593e5f662d9d52a98c49379"
    sha256 cellar: :any,                 big_sur:        "d617acb8d874794b965f7684a246848deeb105521cafaff1ac9568e1d2e1154a"
    sha256 cellar: :any,                 catalina:       "ee7ab713ac1a0af42a02db7d85d9cb3e37643d704733ce0a334cbcc552fe85dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d59a0c7861d9b1887702b995d409edfed115b914c8ad19231ae5c35de1b3f14"
  end

  depends_on "cmake" => :build
  depends_on "asio"
  depends_on "openssl@1.1"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cxx, "-std=c++11", "-o", "test",
                    "quick_start.cxx", "logger.cc", "in_memory_log_store.cxx",
                    "-I#{include}/libnuraft", "-I#{testpath}/echo",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lnuraft",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "hello world", shell_output("./test")
  end
end
