class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.0.6.tar.gz"
  sha256 "c84440ac94928d3e8cd959c4aa0104cddd134bd00844c437511af20edaf8d5c1"

  bottle do
    cellar :any
    sha256 "155727789272a8667873287a007474ca28de84109b19e7275a59d5597fb802ca" => :high_sierra
    sha256 "cccbefba2e48dbe69d7331af1d6e649192a31f57451945bfbc97d25472a009d6" => :sierra
    sha256 "b1b837600c126788c34e5b4e290901a551f46edec20fb177e8943a7f1d25fdbc" => :el_capitan
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
