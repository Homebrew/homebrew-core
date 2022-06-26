class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.3.1/pgrouting-3.3.1.tar.gz"
  sha256 "70b97a7abab1813984706dffafe29aeb3ad98fbe160fda074fd792590db106b6"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c66eb80393f739a22a57a7eef29c86ee9c16962ef90ec369af8a80a76ec37c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bccf0769732a401200741b4ee41809eaea330b3e05ff708cf9c33bbd86fe9cb"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed75a03862e36e511a8f222db0f9dd31f041e88a906dc4c002f84402e96d0d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d11dcf880802d63a413b62a69dff57c7db7615ffc9ae6f7f7142404800d68f5"
    sha256 cellar: :any_skip_relocation, catalina:       "dc4f42b88c4c43ff129f7c3958642ab0a249c0d5382a973d63bf43a57d6bbb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d09ea77bc4dee5df2a344862ba422019b7bd14706baac2ceee72d59396f83eb1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "libpq"
  depends_on "postgis"

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    libpq_prefix = Formula["libpq"].prefix.realpath
    libpq_stage_path = File.join("stage", libpq_prefix)
    share.install (buildpath/libpq_stage_path/"share").children

    libpq_opt_prefix = Formula["libpq"].prefix
    libpq_opt_stage_path = File.join("stage", libpq_opt_prefix)
    lib.install (buildpath/libpq_opt_stage_path/"lib").children

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
