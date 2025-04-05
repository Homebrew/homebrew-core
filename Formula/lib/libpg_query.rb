class LibpgQuery < Formula
  desc "C library for accessing the PostgreSQL parser outside of the server environment"
  homepage "https://github.com/pganalyze/libpg_query"
  url "https://github.com/pganalyze/libpg_query/archive/refs/tags/17-6.1.0.tar.gz"
  version "17-6.1.0"
  sha256 "a3dc0e4084a23da35128d4e9809ff27241c29a44fde74ba40a378b33d2cdefe2"
  license all_of: ["BSD-3-Clause", "PostgreSQL"]

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/simple.c", testpath
    system ENV.cc, "simple.c", "-o", "test", "-L#{lib}", "-lpg_query"
    assert_match "stmts", shell_output("./test")
  end
end
