class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.1.3/pgrouting-3.1.3.tar.gz"
  sha256 "54b58e8c4ac997d130e894f6311a28238258b224bb824b83f5bfa0fb4ee79c60"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7424d8d1bdd429b880334d99310c96a818081dbd0ff7e53dba6b9c02d6ff255c" => :big_sur
    sha256 "287799f4aa536484337fae2c368adb56b956d24f9b8f5000b9de3ac766c3a86d" => :arm64_big_sur
    sha256 "e5405302217126a60aca29ba25e2329dccccce81295f56134e1aeda600502950" => :catalina
    sha256 "ec66fa1e4d1251ddd476aeef4287cfee248991fb094472b7baf41b3e922bcb6b" => :mojave
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
