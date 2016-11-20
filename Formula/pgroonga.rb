class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.4.tar.gz"
  sha256 "e1b20d9266933996c5c22598dddf8d02af343f5b86d75a526998989db1e24a1b"
  revision 1

  bottle do
    cellar :any
    sha256 "eb0ed3f401c74cd376b8dd1b02441402ab47ef2921138ed1eb14a9eb2e26f19e" => :sierra
    sha256 "3f24a1587d0515de617b304e01411aff7ddec9b39a381621ea906f84a86f618f" => :el_capitan
    sha256 "93607ddd01fd0e8e7bfa603dca093475cf2022dfdc43e97db8b055204f266d4f" => :yosemite
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
