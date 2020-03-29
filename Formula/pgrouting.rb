class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/archive/v2.6.3.tar.gz"
  sha256 "7ebef19dc698d4e85b85274f6949e77b26fe5a2b79335589bc3fbdfca977eb0f"
  revision 2
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e16069bdff854de4c36c78323a486e5a2dad731a4a0f978cceb5cff0c29e24a1" => :catalina
    sha256 "c6780faaf6730a4e64e066002f07170385552a71b7b4e408b80c8db09be40666" => :mojave
    sha256 "df9def3ea12a91c30f193a0de2a0c6214de51b27f7621d173d3117db51cb1651" => :high_sierra
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
    return if ENV["CI"]

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
