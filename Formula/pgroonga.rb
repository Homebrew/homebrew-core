class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.2.tar.gz"
  sha256 "4d644f9e59661e5aa8b1cd372d5aa345f976b0aae850523e287274110f394300"

  bottle do
    cellar :any
    sha256 "66f739e958fcd32c2086994acf18e7495ee13c3a8b014c17417204fee23bc6b3" => :high_sierra
    sha256 "fb939dbc804483176c6bee849b4f113cfd645914972e15c92dd13fa2da09f21b" => :sierra
    sha256 "1172060837ed494bc5e55cba0676fe5910deffbd6ecdd1526f0e697c666cc8ed" => :el_capitan
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
