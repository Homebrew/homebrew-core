class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.2.tar.gz"
  sha256 "d5a010c8adc68e026b5e8298fc0d707c81ec0c847c9a97cb4a36bc132f15bf5d"

  bottle do
    cellar :any
    sha256 "b44a4ace1580f94346ef0e14a2194ebe47246e023c42e5a7f2571b52ec2b156b" => :catalina
    sha256 "53a14b9e8754907ebce4b69b3906f49186bebd8c61f1b875ce62e0c5ef987e5b" => :mojave
    sha256 "4f1bd67d861b575979c957edeb9dc2cbd4a310cdfc9be4cfdf4019737a01cdf9" => :high_sierra
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
