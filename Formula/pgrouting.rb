class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.3.0/pgrouting-3.3.0.tar.gz"
  sha256 "a0953d98a2ce7d7162448bc31f17eba1950ce252f7f292a4953e6291237a16dd"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e0ebfc58d08e965ad5e726f850151dd91838224671936e946d046ffe2db2101"
    sha256 cellar: :any_skip_relocation, monterey:      "d0776935c96441cf3467b1b522760de5e617496e3cee0abab89981f125ed573d"
    sha256 cellar: :any_skip_relocation, big_sur:       "8160f9e8421d16996fe418bf82637acc0cf9eafe72a6e482df8dca5e41feb404"
    sha256 cellar: :any_skip_relocation, catalina:      "e649753bce351dde13226665c14f5260302d3fd010880f52c2783133f0144974"
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
