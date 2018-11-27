class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.1.6.tar.gz"
  sha256 "89eb70c1df6a4ca33aa968ae3d8169ac481cdbbfa73b385f27b77c5aab5b9ee9"

  bottle do
    cellar :any
    sha256 "2d5e7168531bf71de616c0d0cc7be33e3cc9614bbe03032fbd663ddbe1006688" => :mojave
    sha256 "6110ddc1862ceb4973b9d847b672498844d91ecc423faf73883f016049dd7901" => :high_sierra
    sha256 "f032f8ea3e124833e1c5c3ba194d8c11eee125c742db180eca25e4547bf440a5" => :sierra
    sha256 "1a639122d7702ece1f30d5f127c74926d3d9ed4ca3bcb1137f2f38477b02c7f0" => :el_capitan
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
