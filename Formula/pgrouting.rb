class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/v2.5.2.tar.gz"
  sha256 "9251d5955e00456ce8fd7f4fade0f40158687fd58814cbb961ba3588edc31153"
  revision 1
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "5a642c2d88ebaa7e0a0f9ae9369a716dd6dc2ab97c7fa4969c477be85b9490c8" => :high_sierra
    sha256 "41d721ab350e6c2e3ba26c7178581c6a2935e089af7b366a738311ded552a998" => :sierra
    sha256 "f98c878047ae5b781926f2d771cf11c6937df2a4938a24f58042d5c652167f38" => :el_capitan
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
