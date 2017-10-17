class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/v2.5.0.tar.gz"
  sha256 "2c97df865484bf4e4e6f059b535b63bbe64534076b9d0c4bdd494f916fa24e9d"
  revision 1
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "ceba4f2f36a6789b2626fd12b1fb62c9b31a54e1a1950e90135ce4df69339ac1" => :high_sierra
    sha256 "ec901b925ad48e7cee9dfa74b293c9c696a81ca500f5e2033fa5301ac80ce2e9" => :sierra
    sha256 "5dee6b1dd5cf8bd72f18ec7f534e0ebf29d4c10a9e55021b50cac60c07550c1c" => :el_capitan
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
