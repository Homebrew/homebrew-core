class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.2.4.tar.gz"
  sha256 "34ccf2b1acd076ad7da92c0692a114d0b607b84771fdfd4e131246ef2c66bf84"
  revision 1

  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "8a511d98a83830b7e8b2c86831eac254bcbde507726c001a369f943fd5f6b778" => :sierra
    sha256 "c71db8f54805e0278d1be93d1e7a638968d392b877be093cbc08d8db2556233c" => :el_capitan
    sha256 "64ba007f1967c02f0383198053a02196e30b1ae9993895d5828bddfd01596bd8" => :yosemite
  end

  devel do
    url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.3.0-rc1.tar.gz"
    sha256 "c903d6dab0e48b987a9906eb8331e1bc18f78143d41db8888dee06d2d8c5ce4b"
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
