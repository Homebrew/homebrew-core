class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.2.4.tar.gz"
  sha256 "34ccf2b1acd076ad7da92c0692a114d0b607b84771fdfd4e131246ef2c66bf84"
  revision 1

  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "a7e1ad7075c68bd8fb106c674d02e41c0f1355b1bb543a4d9866066010fe36ec" => :el_capitan
    sha256 "7952d9fd3df110572c679b13779dc4071ec6fa3e3f6985c3ae836d50d7ed8be3" => :yosemite
    sha256 "5590580dca418a3df909e11fd074dff56eb25b54dae81d28b348d58b0c5bf48e" => :mavericks
  end

  devel do
    url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.3.0-alpha.tar.gz"
    sha256 "8ef18bfec0c6b0b8d3d933a95b49a3276e0b1dabd419f66cae187711bc9e6256"
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
