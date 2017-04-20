class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-1.1.9.tar.gz"
  sha256 "4f19b2ac3fef7299a9324ec84d521a5c4a9f01df190f1eff59ae5b44297f4e1d"
  revision 1

  bottle do
    cellar :any
    sha256 "cf09b1a5298840c222507f58f12eae4945d94dfb7a525d989f2dee2a9a17f9cc" => :sierra
    sha256 "b3f2459cab54faffbd03ec745cff048c920c76ee4d53631e5a2b9fdbd18937ec" => :el_capitan
    sha256 "80755812f6f164b1421915e8fe46454ff21d3deb73b3b6491a04cdc4d1d3bf1b" => :yosemite
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
