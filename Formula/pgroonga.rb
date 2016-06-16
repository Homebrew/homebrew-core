class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.0.tar.gz"
  sha256 "859c000485f718a8e3c068c810e40d44afeea789f1af56935fa2300f83dc86fe"

  bottle do
    cellar :any
    sha256 "41035f1c2b0300c5ddda5d564ffcd846bf7db3bfcb40e0b78542e22ed93dbfa0" => :el_capitan
    sha256 "964c2385112cb8e1d30eea9cb1212772f6c2aa232c769375d637e2a8608b3f59" => :yosemite
    sha256 "affc71062350ddcbecda8ea28eb4303d57527ec1141d89abe5b2d32b09ed1a8a" => :mavericks
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
