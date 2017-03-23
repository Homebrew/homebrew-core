class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/v2.4.0.tar.gz"
  sha256 "fe4733afba6c94d87145f9b90744d888312314530576a35c90016f2826d30297"
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any
    sha256 "cb67355aa7d3ed417632b3cd8c6dd6d435b245f9f5c2fafc21431b0bf59269a4" => :sierra
    sha256 "e6fb19d18de31dd6bda92ea7bcf756942531caec218eed98cf2f3769a5979a83" => :el_capitan
    sha256 "c045bf01a7214435ab33ba178f0782449d1b8637fef820c590c8439c4d43fe9d" => :yosemite
  end

  # Fix compiling error #767 for version 2.4.0
  patch :DATA

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

__END__
diff --git a/src/bdDijkstra/src/pgr_bdDijkstra.hpp b/src/bdDijkstra/src/pgr_bdDijkstra.hpp
index 56bd888..f792deb 100644
--- a/src/bdDijkstra/src/pgr_bdDijkstra.hpp
+++ b/src/bdDijkstra/src/pgr_bdDijkstra.hpp
@@ -81,7 +81,7 @@ class Pgr_bdDijkstra {
      }
 
      std::string log() const {return m_log.str();}
-     void clean_log() {log.clear();}
+     void clean_log() {m_log.clear();}
      void clear() {
          while (!forward_queue.empty()) forward_queue.pop();
          while (!backward_queue.empty()) backward_queue.pop();
