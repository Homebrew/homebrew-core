class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.5.tar.gz"
  sha256 "ff9962e4f5e54deb9876720739cb10bf0e14e4558e9ee636b96ea6de664a9253"

  bottle do
    cellar :any
    rebuild 1
    sha256 "458692b4139547d2660c7e859062fa2b2106da8e3ef8852950c73398bfd5b147" => :catalina
    sha256 "1d5e7bddbb7ac76384681638fcb9f549a2be37491a33bc1aa8f869b9b72ed677" => :mojave
    sha256 "2b968c6c23d92257b60a166a29efd74f714a0e4c15cfe8b6d16ab6e79e1e56c2" => :high_sierra
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
    return if ENV["CI"]

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
