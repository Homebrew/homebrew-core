class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.2.2/pgrouting-3.2.2.tar.gz"
  sha256 "40f67ab944b5a7d91d4eb610cba3ed34a83daf51bb569c75b582f8e88efb72de"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76932cef2d904040657edf67e10c65739a1f8b474cda8e52c246706758744b1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bba2a9361392e38ba82e0fcef06696faf5dff487f1c034f9a1b31bea164dc98"
    sha256 cellar: :any_skip_relocation, catalina:      "9a08889b19513cbcfbb70c8c2bf9eb29aba19e9e9691f298afcbf24118961bdd"
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
