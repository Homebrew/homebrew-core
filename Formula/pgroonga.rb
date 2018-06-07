class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.7.tar.gz"
  sha256 "706d934adf57bea918fa529d8ab8739e0153f3d49821c9e7c7fc719aebd19af9"

  bottle do
    cellar :any
    sha256 "8f8022f0bd62ea331400648e4925b0fd558a4d55f59d21261b6fc87ca9e27457" => :high_sierra
    sha256 "2d27e8ed92df0293e19a3b4a99da1e12ddde52341f57964966c20a4f77280868" => :sierra
    sha256 "e2f55227016a5f03cb6d77ee7c88251aee83602870f4842879d0a261af223c90" => :el_capitan
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
