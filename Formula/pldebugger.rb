class Pldebugger < Formula
  desc "PL/pgSQL debugger server-side code"
  homepage "https://git.postgresql.org/gitweb/?p=pldebugger.git"
  url "https://git.postgresql.org/git/pldebugger.git",
      :tag => "v1.0",
      :revision => "ca1041dc3db6f516899be669dc6fbfd6339f8168"
  revision 5
  head "https://git.postgresql.org/git/pldebugger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6451509ba068ed7218ee670c533eb608223ded3f5ee77e103e561a28b5e2ae0e" => :mojave
    sha256 "7e374cae3302be2d942f4cda8f81952705cf415c5544de6ea06a90133d0e4c3b" => :high_sierra
    sha256 "b6ff141375d5ea2a271fb230369afba1bbc17ca0d247a7a949e2e4485c46d7a6" => :sierra
    sha256 "e513476dab1d03c3a316a7f6221fd647a001dc539f531f4f38c62a31862b011a" => :el_capitan
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
