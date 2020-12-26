class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.8.tar.gz"
  sha256 "6030cedede8045b42fef6428b6303b0cdc4e951a363b9098ceb1fefde1338f7c"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "7cf0bdb802bfd5d6aebb115f471266e61ee406a73048d2555d400bf3080f1fef" => :big_sur
    sha256 "fe3ea9eb151ac26aa96c2eb88095f2c2acbc20fa38ce01c5c684a1ee20413aa2" => :arm64_big_sur
    sha256 "d0de2d71d1d643d130ad2823d51b3cf06e38f5d48158fc40fcba1d697b2f73fc" => :catalina
    sha256 "86e7ae187aefe8db8956cee2457d7434039d5dbb9201457b7b12fae604c22c12" => :mojave
    sha256 "43c3241de15a83eb86978ad51c103e42813357cdcc5629858ab8ac571da4c031" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql"

  def install
    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    return if ENV["CI"]

    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork { exec "#{pg_bin}/postgres", "-D", testpath/"test", "-p", pg_port }

    begin
      sleep 2
      system "#{pg_bin}/createdb", "-p", pg_port
      system "#{pg_bin}/psql", "-p", pg_port, "--command", "CREATE DATABASE test;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pgroonga;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
