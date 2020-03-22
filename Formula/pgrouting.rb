class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/archive/v2.6.3.tar.gz"
  sha256 "7ebef19dc698d4e85b85274f6949e77b26fe5a2b79335589bc3fbdfca977eb0f"
  revision 2
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "1fd00deaacb827085f5da2db9904c730484f84c83a5266afc4bd5de26d228a9e" => :catalina
    sha256 "1f947e5cef6eac50a0221a0fcceae694ef0142b8b44af76a2110762e97805660" => :mojave
    sha256 "8714a692bac159642193e8557c3061a2802fa419a826d8928cc559513583e3d1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql"

  # Patch for CGAL 5.0. To be removed next release.
  # see https://github.com/pgRouting/pgrouting/pull/1188 for fix upstream
  patch do
    url "https://cgal.geometryfactory.com/~mgimeno/pgrouting-for-cgal-5-0.diff"
    sha256 "9dab335d9782b1214852d85a3559bc1092ea95b9abd6b5701759799050005c98"
  end

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
