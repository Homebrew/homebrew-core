class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.2.1/pgrouting-3.2.1.tar.gz"
  sha256 "daeb7ba8703dde9b6cc84129eab64a0f2e1f819f00b9a9168a197c150583a5fd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e9bacec2bd498eca143e7363d80ba0e120c6862f2342e9cd575d535b8133b32"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9a2a7d7afa90612d6912d0efc6f03f2148842068037b85cf52d7147a0dd0a28"
    sha256 cellar: :any_skip_relocation, catalina:      "960f79919d4e22d15ce1af503e1ac324591fbeea92f6f25d8a545d398346b54e"
    sha256 cellar: :any_skip_relocation, mojave:        "643bd796709017250272299c1419d172dfb305ebbdae0c2f63698420851dc379"
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

    # write the postgres version in the install to ensure rebuilds on new major versions
    inreplace share/"postgresql/extension/pgrouting.control",
      "# pgRouting Extension",
      "# pgRouting Extension for PostgreSQL #{Formula["postgresql"].version.major}"
  end

  test do
    expected = "for PostgreSQL #{Formula["postgresql"].version.major}"
    assert_match expected, (share/"postgresql/extension/pgrouting.control").read
  end
end
