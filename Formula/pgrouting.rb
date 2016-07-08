class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  head "https://github.com/pgRouting/pgrouting.git"

  stable do
    url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.2.3.tar.gz"
    sha256 "ace0b2bfcfd468fa360867faf021d4447ebfa80d35f02cf5da549503b5dd4892"

    # Fixes "use of undeclared identifier" for "ceil"
    # Upstream commit that adds "#include <math.h>" to VRP_Solver.h
    patch do
      url "https://github.com/pgRouting/pgrouting/commit/3862e4cb.patch"
      sha256 "936af1d25d3aae517de1d2cff021d8e6c5f7db98927ded5d699caf1bc535c1fb"
    end

    # Fixes "use of undeclared identifier" for "srand" and "rand"
    # Upstream commit that adds "#include <stdlib.h>" to VRP_Solver.h
    patch do
      url "https://github.com/pgRouting/pgrouting/commit/ce811a03.patch"
      sha256 "628c68f3d2348f60b3612a04868dc96797e2a357db18c41d62717fd70c3c5747"
    end
  end

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
