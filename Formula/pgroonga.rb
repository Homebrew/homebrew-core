class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.0.tar.gz"
  sha256 "859c000485f718a8e3c068c810e40d44afeea789f1af56935fa2300f83dc86fe"

  bottle do
    cellar :any
    sha256 "521693f9c217a778a895a6568261291cbd65a342ffb9511fa0adba4e82c242c6" => :el_capitan
    sha256 "63842e3af7f47a43c6240f594f625324f8cbeb07f0fa8fcb40f1a76518c3b13e" => :yosemite
    sha256 "615c40868d9878b9a69d8253f7afd9ddd22a1e1a1332a5bcc51dc0539f3ede86" => :mavericks
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
