class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.1.6.tar.gz"
  sha256 "89eb70c1df6a4ca33aa968ae3d8169ac481cdbbfa73b385f27b77c5aab5b9ee9"

  bottle do
    cellar :any
    sha256 "9ad911e45c69579b6dafdcb77f1f385f6b0e892d1b3ce6329c65610608d0e885" => :mojave
    sha256 "12d6ddeedfa97db70b6ee48d0f7a5826c31b57aae08d08c00bc9d09a395d3e8f" => :high_sierra
    sha256 "87ceb97908a013d3c28d49cf0d638048ea745f441a7c4bc56b09ac2063476ca1" => :sierra
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
