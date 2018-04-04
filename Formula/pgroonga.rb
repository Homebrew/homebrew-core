class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.5.tar.gz"
  sha256 "aabc20faef17084d2f01ea2e0caa4d7bd0445492fafcd76c465e88305e0e95b0"

  bottle do
    cellar :any
    sha256 "044b392b30d552f84388306cbed5cf5701b2effb39cc2981d29297e6a480d7c4" => :high_sierra
    sha256 "88018d7db9cc5895a2e931d31cff2ac82fce036d1cb0cedd574f642713134851" => :sierra
    sha256 "ed782c5bde35fba409798c21c106d0b791094a4574cf488f3e3aff27e353db9c" => :el_capitan
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
