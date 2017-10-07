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
    sha256 "31c78de62ec15c0010d5e341b2fc4c947f337379fbc03e160773f2703fb66f31" => :high_sierra
    sha256 "c672b8a6594087205bdf0e700a2563b34be401d1553172386296f558f6848e9e" => :sierra
    sha256 "62e41779ae932b596865c17343ed72bc6fb2ced041360c4df95b5ec2e5555be0" => :el_capitan
    sha256 "322f10ac752eafba3f029c2edb59a9cb63fcc09c76f8751619cd835df46c8122" => :yosemite
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
