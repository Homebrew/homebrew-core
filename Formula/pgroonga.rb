class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.9.tar.gz"
  sha256 "4f19b2ac3fef7299a9324ec84d521a5c4a9f01df190f1eff59ae5b44297f4e1d"

  bottle do
    cellar :any
    sha256 "a1f19145ed7dd4b875f1b53f56009c461e642a9860d7309d0d4c07dbd9e23d11" => :sierra
    sha256 "9166b13a737bd78680ae37cf96cc52266d75d429901f79f6442cbdc26134ae73" => :el_capitan
    sha256 "7a01ec87396510e6f1c9d5a783b463e8a57c111a57a0481bac7ec31b66799fb3" => :yosemite
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
