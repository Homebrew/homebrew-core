class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.1.tar.gz"
  sha256 "68ddb538b14917f89fb6c71846ac736de2ebc7d799a56fb69a149bde671e2135"

  bottle do
    cellar :any
    sha256 "15e1584a853f70a64ccb2e1285bd4bde7a8924e9c78b9c09eeb8401231a80bb1" => :mojave
    sha256 "50df1b2525a3763cd493df1acd44df3faeeccb50d258cd2d0cbe6e70666e0c62" => :high_sierra
    sha256 "ca843315151b2ab07b54e92f4f99cc2940beb7ef66c81993205988abbd7bf688" => :sierra
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
