class LibpgQuery < Formula
  desc "C library for accessing the PostgreSQL parser outside of the server environment"
  homepage "https://github.com/pganalyze/libpg_query"
  url "https://github.com/pganalyze/libpg_query/archive/refs/tags/18.0.0.tar.gz"
  sha256 "6ad7783f272acfd116455c66a03298a0cac9a9168281df547969219112f0260f"
  license all_of: ["BSD-3-Clause", "PostgreSQL"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e760f32180555c1627c49bdeca785d9eee4ea71754603fef4d9555bd7399c3f5"
    sha256 cellar: :any,                 arm64_sequoia: "cc37d9d91d98a50f29b32e33219467a6d5b4c303732c75b08a6887e68a042e66"
    sha256 cellar: :any,                 arm64_sonoma:  "02898261bf6b12bc0bbcd0da0a16d9fd9c345c91831809722f360637e470a9b0"
    sha256 cellar: :any,                 sonoma:        "ac92b960fd6a94d149d8d78473bc7dce5fa96018b1b99447b08b1a246e0ec42d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ba15e2b97d2738c79047146cc5d76d1fe6038782acdb24866ae10b96ac602e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f75a23ed39c4aa6d5a705ab2fbe300eb27a1737b4a08e77dd5d8671dfe65cb"
  end

  def install
    # Turn off strlcpy(), it is working only if glibc 2.38+ on Linux.
    if OS.linux?
      inreplace "src/postgres/include/pg_config.h",
                "#define HAVE_DECL_STRLCPY 1",
                "#define HAVE_DECL_STRLCPY 0"
    end

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
