class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.2.tar.gz"
  sha256 "4d644f9e59661e5aa8b1cd372d5aa345f976b0aae850523e287274110f394300"

  bottle do
    cellar :any
    sha256 "11bff1f45d9e6f1f633285c071da9d71ca441e74e1638d67bf37c3705b8eeff8" => :high_sierra
    sha256 "1e43cf3e31c4517f71dfc661895fb0b94ddf6addb25b4841171674f89675f680" => :sierra
    sha256 "ef3ec18dc482103a27c1777b9385d9deea506ebc22b496aae334a7660b4f14a4" => :el_capitan
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
