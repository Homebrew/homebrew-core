class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.7.tar.gz"
  sha256 "706d934adf57bea918fa529d8ab8739e0153f3d49821c9e7c7fc719aebd19af9"

  bottle do
    cellar :any
    sha256 "6ebc1a553ee45580040e2eec7d5d4c1dcb1c174adbe3374ed89eb106db8350f8" => :high_sierra
    sha256 "25a44e6e2de6fc989e70f6393f03333f5a8dfec5146ae576bb80df840dea747d" => :sierra
    sha256 "de32c9edde09b51afb1d2c6343056f5245c83397c976b5220a42ac6d7061eaa4" => :el_capitan
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
