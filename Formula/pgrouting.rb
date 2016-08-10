class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.2.4.tar.gz"
  sha256 "34ccf2b1acd076ad7da92c0692a114d0b607b84771fdfd4e131246ef2c66bf84"
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "3ff9bc24fb3e040c71d17983a3fe0e86fcf994d0de66fa5b8be80ecb92e1f5f7" => :el_capitan
    sha256 "d7f61ceb885f514970408d4d94c02627765244a40bbe210058c4c4e1bb0a78d6" => :yosemite
    sha256 "390ef2d5901a851c43c83381b2e77f0c63bab2e4ab4a9993d39b67f17ca7a6cc" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

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
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION postgis;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pgrouting;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
