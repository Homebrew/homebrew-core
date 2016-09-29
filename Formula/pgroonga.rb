class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.1.3.tar.gz"
  sha256 "b160973b5573f3acc3be2d0b29a91441498af39201ffdaf06b9824e6705d920c"

  bottle do
    cellar :any
    sha256 "1005a46c759c7ef3e8af6a2a94db3c4c3ec08e7d019bbcfb0dc270219a3dd4c1" => :el_capitan
    sha256 "7ed7849ffda7744b49d047ea6275a0463c671409a74bb0b47481466a386a5e96" => :yosemite
    sha256 "76809c9112bc2cbcb485e3172f2df8dab989423f8165f8e2b15a77ec72304e6f" => :mavericks
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
