class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.1.tar.gz"
  sha256 "68ddb538b14917f89fb6c71846ac736de2ebc7d799a56fb69a149bde671e2135"

  bottle do
    cellar :any
    sha256 "f6b76686cf82b90e8891c9dc18a74b57ba7447c2c121b53dfba8f457ed932901" => :mojave
    sha256 "1083a0b4c75c913e4186ec5bacab43630c8136d4045c358cfa9f80676babd0ec" => :high_sierra
    sha256 "865afea0ab2abfbb03e3540adcbbf0a846265ec316f5cff7fc42e8e3f7e13ae9" => :sierra
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
