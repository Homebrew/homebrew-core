class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.1.tar.gz"
  sha256 "1d6d6fb30dcf2348efaf95979c5549fbda1ffb8da5645cacd530958783540ee2"

  bottle do
    cellar :any
    sha256 "20fe9234d6c705a3299a869384dbf561671397cf7b43865fb13a6823a055b536" => :high_sierra
    sha256 "bba268d6644e47c8564541ab105dd90ad983f5fc7514fbf3bc5bccaec6703538" => :sierra
    sha256 "abd23fcee83c8f40e05a770da201c882c22f4c76d4983fb6c4bdd9a673ea907d" => :el_capitan
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
