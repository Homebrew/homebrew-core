class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.8.tar.gz"
  sha256 "6030cedede8045b42fef6428b6303b0cdc4e951a363b9098ceb1fefde1338f7c"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "58f39a403151e4110941062db18220b0d15f8de6377c178bf3aaeda39e9f686a" => :big_sur
    sha256 "488119d71f44926797d38b6e69cfa00b2d10d1cfcb390166516d99bfba933091" => :arm64_big_sur
    sha256 "1e6749eae1974a8216f6f8564fe7cf79d0bb85e57f76e4c773acd741308f6a17" => :catalina
    sha256 "c5c37e09d2fa0a7b202be2a9f0bccc35c5d51965d2c9db53257d5d654ad3fae6" => :mojave
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
