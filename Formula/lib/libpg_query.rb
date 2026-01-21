class LibpgQuery < Formula
  desc "C library for accessing the PostgreSQL parser outside of the server environment"
  homepage "https://github.com/pganalyze/libpg_query"
  url "https://github.com/pganalyze/libpg_query/archive/refs/tags/17-6.2.1.tar.gz"
  version "17-6.2.1"
  sha256 "678434d59511c8892c37ba5b9816ab641bd007cef2eda215b2297c39b79c861d"
  license all_of: ["BSD-3-Clause", "PostgreSQL"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7ac671a9f6a473804c6e8d35d1315f3605dafcf607669dfd25a9e212ca84135"
    sha256 cellar: :any,                 arm64_sequoia: "9ab75fa1681cb5dbbed5bdc163bbf34754170532e927e6accdad9b3dd1ae4e5a"
    sha256 cellar: :any,                 arm64_sonoma:  "69f7951383df6b26b84eb5e69400e2c6612dd438055e9335482142c01c8a09e6"
    sha256 cellar: :any,                 sonoma:        "eb2aaf54780882b089cff93eabad8c4e108c4576e44291107834b30222bc74a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66732147d9a8bbe39081cf799ad4075ff31bea39c66dd2c75fd1a342b278e12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a819fc4660a0552e70f8d2895b68d44e6240d3e4d140eef5c1a2ab1f05fb414a"
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    include.install "postgres_deparse.h"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/simple.c", testpath
    system ENV.cc, "simple.c", "-o", "test", "-L#{lib}", "-lpg_query"
    assert_match "stmts", shell_output("./test")
  end
end
