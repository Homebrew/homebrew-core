class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.7.tar.gz"
  sha256 "a0067532dddd2d12491815b9b1f48d6b9131150de4827ab2131d50a72707f258"

  bottle do
    cellar :any
    sha256 "90b1771128d7554c38f0ad8923e74b586289a96e377fcece8e21c83b32c136e1" => :el_capitan
    sha256 "3d9a88e33f6c2083e5fd5232ca8974656371003d53f57c4d8c9b1af6f9991b98" => :yosemite
    sha256 "ac6d35c887df2102e9274ae11a341aee2c702e2c385995bb9d05a92dd9818c11" => :mavericks
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
