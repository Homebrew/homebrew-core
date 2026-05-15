class LibpgQuery < Formula
  desc "C library for accessing the PostgreSQL parser outside of the server environment"
  homepage "https://github.com/pganalyze/libpg_query"
  url "https://github.com/pganalyze/libpg_query/archive/refs/tags/17-6.2.2.tar.gz"
  version "17-6.2.2"
  sha256 "e68962c18dbf5890821511be6c5c42261170bf8bfd51a82ea9176069f3d0df8b"
  license all_of: ["BSD-3-Clause", "PostgreSQL"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9bdc5200f8cc312f042c1344a0095630089c3dd7b8eabc2d838f04bf0dc42ef"
    sha256 cellar: :any,                 arm64_sequoia: "dc9128ec138bed2e6fc21cc14090e71e9a9ef081f482926d3dc199df4256e4dc"
    sha256 cellar: :any,                 arm64_sonoma:  "47d822f4b8e0ecf1d9fc8213b74515cb1988bc2200c43dc4009b732c669624ff"
    sha256 cellar: :any,                 sonoma:        "3e6a4c87bebc0c023c2fb67271d5818c3106d34722b168f6a76ed907926c3217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30578cfe44c07ca93be284e150ca765e9f5a09e3a22fd5b51a3d4111c8ee357a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccab7e14472565d73b8d728fa9cb202d20516f673727920dc2ad56c513e35a71"
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
