class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/v2.4.1.tar.gz"
  sha256 "11d225391cdac8e15136a51664b22fa007d10cb78bf8208374470a9044850fd4"
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "edb3c2e6f5a59e8249d410c815a0a491892f4583dff73338fb4b77bd28849a2d" => :sierra
    sha256 "591f6bd27222efb31cdd553c78e09cb554cc725d3ab5fec2b55574f2a00fac75" => :el_capitan
    sha256 "7f09f0118cd1995183d03d0245ef85d43f07e11bc2e7d11ef9703c9c4d6caf68" => :yosemite
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
