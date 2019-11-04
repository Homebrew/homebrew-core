class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/archive/v2.6.3.tar.gz"
  sha256 "7ebef19dc698d4e85b85274f6949e77b26fe5a2b79335589bc3fbdfca977eb0f"
  revision 2
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "5082abf1c48e77ff3adbde7667689676ffd4e398bfc2897e7cf636c07e4f911c" => :catalina
    sha256 "8d86dbbe3ab8589ad2dab7d567510caeec58a2ae027ef2a1c87597032f4ffd60" => :mojave
    sha256 "76fd2839fd83677abf987de63c756eaf2ca3f090d787efe6400c818c5979df16" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql"

  # Patch for CGAL 5.0. To be removed next release. see https://github.com/pgRouting/pgrouting/pull/1188 for fix upstream
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
