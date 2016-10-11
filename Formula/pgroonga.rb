class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.3.tar.gz"
  sha256 "b160973b5573f3acc3be2d0b29a91441498af39201ffdaf06b9824e6705d920c"

  bottle do
    cellar :any
    sha256 "422d6fb08fc7826c07aee457a8a4abdd969c20dbb77799cfdfde24f0c10ce724" => :sierra
    sha256 "3a7b9c08bbbf4226bb706692a0b9297926abf05a4094de7b657e461132eab087" => :el_capitan
    sha256 "c5e10a79942e9fa0db5e3d85f71b7da274fa6bd22e95c6a45edd55a7b2488bf6" => :yosemite
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
