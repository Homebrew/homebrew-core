class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.3.tar.gz"
  sha256 "beb79ba2505633a505b5d1ebf000c773941f940c0639001f14f9b531e4ec8a4a"

  bottle do
    cellar :any
    sha256 "cc21a916e7ae244ff154085a0ee1815e1c33f0792ad9330e352f3aebab877b1a" => :high_sierra
    sha256 "6d88cb8ec71fd9d853f49ea3950c9b14fb35510315848bfdea7674ca33a0ce20" => :sierra
    sha256 "b7dee16f0e865865e05151fdc63607204e5e86ead875f6328389c1bbf2e89e85" => :el_capitan
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
