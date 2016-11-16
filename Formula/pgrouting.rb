class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.3.0.tar.gz"
  sha256 "cadeed30bfc57f6e77bc48a10301b26e5d71d8e86f366ed60ab5b0eaa0c45662"
  head "https://github.com/pgRouting/pgrouting.git"
  revision 1

  bottle do
    cellar :any
    sha256 "c384f28b1c7b71fcffc1f224f1f94b1a791a92a082966d5152ccd095fef31a3d" => :sierra
    sha256 "f37050810d98e093baee89baf99dee3966bb8acb5c2f35d7daeb76cd828c1866" => :el_capitan
    sha256 "15324de649cd542b85eb733fa41ef2cf6c98e25a42695cb5a0b6f6ecfe93246b" => :yosemite
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
