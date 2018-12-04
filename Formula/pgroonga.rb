class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.1.6.tar.gz"
  sha256 "89eb70c1df6a4ca33aa968ae3d8169ac481cdbbfa73b385f27b77c5aab5b9ee9"
  revision 1

  bottle do
    cellar :any
    sha256 "510707d53e61523286a3ea1df0b6f03f0c7efa51af0d951cc530b31173be2b4d" => :mojave
    sha256 "17e146f66176c97cc127e4ae8aaa9e0c18d0697c360dc811d9f5e725a8aa269d" => :high_sierra
    sha256 "cb5157b2231542471046f2b5875ed0c705e82926ecfe0b3ca4a061780776f44d" => :sierra
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
