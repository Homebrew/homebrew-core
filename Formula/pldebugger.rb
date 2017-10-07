class Pldebugger < Formula
  desc "PL/pgSQL debugger server-side code"
  homepage "https://git.postgresql.org/gitweb/"
  url "https://git.postgresql.org/git/pldebugger.git",
      :tag => "v1.0",
      :revision => "ca1041dc3db6f516899be669dc6fbfd6339f8168"
  revision 4
  head "https://git.postgresql.org/git/pldebugger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efa37867502367f83fede3bab6549a18947f06061649c78d8b2322bd8e9e7da5" => :high_sierra
    sha256 "94208260710242608eea6761a12842a7954d5b7adf03a59f9adf1cba2c7afdb1" => :sierra
    sha256 "fd9a7ce6b0580825e742778fd88581dd2a0830f6dcc3eb101e353b857ce8d1c3" => :el_capitan
  end

  depends_on "postgresql"

  def install
    ENV["USE_PGXS"] = "1"
    pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
    system "make", "PG_CONFIG=#{pg_config}"
    mkdir "stage"
    system "make", "DESTDIR=#{buildpath}/stage", "PG_CONFIG=#{pg_config}", "install"
    lib.install Dir["stage/**/lib/*"]
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
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
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pldbgapi;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
