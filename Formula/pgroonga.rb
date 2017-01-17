class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.9.tar.gz"
  sha256 "4f19b2ac3fef7299a9324ec84d521a5c4a9f01df190f1eff59ae5b44297f4e1d"

  bottle do
    cellar :any
    sha256 "a9c055c1a05fd7cad327cd54f3b404228ab737870654db7e3e2b1e7e9c471e82" => :sierra
    sha256 "273cd384b677e0c3b33911b0efea0ca0788d82a8095c707e6d28712621e4916e" => :el_capitan
    sha256 "3f852a7e61dd3133f401ae00758bd197550ae1a9345c1211292cd2e13bddfd2d" => :yosemite
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
