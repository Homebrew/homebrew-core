class LibpgQuery < Formula
  desc "C library for accessing the PostgreSQL parser outside of the server environment"
  homepage "https://github.com/pganalyze/libpg_query"
  url "https://github.com/pganalyze/libpg_query/archive/refs/tags/18.1.0.tar.gz"
  sha256 "2d3486cf6a9d3955b53e66235db39d62b54216c820cd392ab66dc842c5b1316d"
  license all_of: ["BSD-3-Clause", "PostgreSQL"]
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f0b6079051efd7269309edf8ce2e78753114d910e9d32ea30fab1bb7a44e8ac"
    sha256 cellar: :any, arm64_tahoe:       "b2f8e2ad27549f4fb8c4bcbdc4fe2da63a30277b42b5fb0dc774b6e55cc3986c"
    sha256 cellar: :any, arm64_sequoia:     "a4d6331474f417f6044e55a0c391761ad621f7f2d81ae876b225175af5ca94ec"
    sha256 cellar: :any, arm64_linux:       "b4ac51d9a9448eb56be75bb15403b60569f6f268d7a8baf1107577ab06a120c7"
    sha256 cellar: :any, x86_64_linux:      "9f8b94d7361d655d9154e36a47ff3f6957494e8ae4cb674b62110fd5d6cd0853"
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
