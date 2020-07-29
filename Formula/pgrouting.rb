class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.0.2/pgrouting-3.0.2.tar.gz"
  sha256 "c915f4fb1697fd06611855c4fedf6d9c4d738557e283d15a64f0cacc3ac6fbe7"
  license "GPL-2.0"
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd6dd23b0c6f4d34c9b2da3de38b9226654411bcdba2807b6b9c3664e2e25f81" => :catalina
    sha256 "8ad632ddea0b18f754b5a3712c4455d9f5e0b76a8693884603a72ebdcc0418c6" => :mojave
    sha256 "c67affc142927d5ac604f253789f3f06527640f2ff0ad94675d763ee86fda63a" => :high_sierra
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
