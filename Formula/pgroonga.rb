class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.5.tar.gz"
  sha256 "ff9962e4f5e54deb9876720739cb10bf0e14e4558e9ee636b96ea6de664a9253"

  bottle do
    cellar :any
    sha256 "18e77cc71e81887b33883be924064dabb8f371bfaa59f84e923a09fc98572cc6" => :catalina
    sha256 "144331087d136416381c924b9e4a3574d1fd33ffed3a73c7864b38f1898e3c00" => :mojave
    sha256 "e3c90480324f278c3595773e8c4ed1e8183923675e2a1447cc8bae23188a57e0" => :high_sierra
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
