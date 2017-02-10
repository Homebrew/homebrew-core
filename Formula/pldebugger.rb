class Pldebugger < Formula
  desc "PL/pgSQL debugger server-side code"
  homepage "https://git.postgresql.org/gitweb/"
  url "https://git.postgresql.org/git/pldebugger.git",
      :revision => "4058a938f588397b2923247974eb22106f530ebb"
  version "1.0" # See default_version field in pldbgapi.control
  revision 3
  head "https://git.postgresql.org/git/pldebugger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a2e8697c277409180629468d0dd6c3aeb70d719cef85761049f6ff00a6018f6" => :sierra
    sha256 "c53c1f6345e6550067897b5f1abf7f004176921632c4bfd97ef14b8c38a7f293" => :el_capitan
    sha256 "166830095cc6e34bff38f94a184ba67d729775bb4e4af482d24cf327782a57c4" => :yosemite
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
