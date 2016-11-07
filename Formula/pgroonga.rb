class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.4.tar.gz"
  sha256 "e1b20d9266933996c5c22598dddf8d02af343f5b86d75a526998989db1e24a1b"
  revision 1

  bottle do
    cellar :any
    sha256 "d45ffceee3f9219908570b60323fd93e8663f9bee1da941784231de9afbdcfc2" => :sierra
    sha256 "8c5c3b4376cf8baa1fea2f6c9a99a8ca598886468ebf9996a69bcbcdfef38c2a" => :el_capitan
    sha256 "50b8e8dffb4ac244b1502b8b730b3d748bd9c8617449c2f7f3b7113fa900f84c" => :yosemite
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
