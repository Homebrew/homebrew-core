class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 6
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "249f8e13597c4ed5126c539d71a62802583f2d4819d90164db81667a4961f3ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae590b6c6ec538091753be46008aaa0f3b9ff38482b8936a2fd2598d079fad5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1937e9a80d0cb322bf7612eb67e7f191f420e4fddb85090bece51b507e14232c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cd0daa313e88fa553b9334ed07f24e8246e761d539e497d2b62c3aa1c4d1522"
    sha256 cellar: :any,                 sonoma:         "4a155e281801cc5d14fc281fe9e58404132a797227f043b44351737c03c5e8e0"
    sha256 cellar: :any_skip_relocation, ventura:        "647a95d770753b5e803eef33460fc44ec06f2abaff906301d0343897c34d2818"
    sha256 cellar: :any_skip_relocation, monterey:       "b170b1831a4793b29565df3b956d0c54a1948e7bfb72d198498ae51c19ca9869"
    sha256 cellar: :any_skip_relocation, big_sur:        "333769d1c641b3af3e8d1692077b042bd1daf04a79871cb593219f353433675f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bab5202fa668f96ec7f04fb22b3a2379dd6e26a3209d0428480e4456da40d27"
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "libspatialite"
  depends_on "libzip"
  depends_on "pdal"

  # Build patch for xcode 14.3
  patch do
    url "https://github.com/DroneDB/DroneDB/commit/28aa869dee5920c2d948e1b623f2f9d518bdcb1e.patch?full_index=1"
    sha256 "50e581aad0fd3226fe5999cc91f9a61fdcbc42c5ba2394d9def89b70183f9c96"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/ddb", "--version"
    system "#{bin}/ddb", "info", "."
    system "#{bin}/ddb", "init"
    assert_predicate testpath/".ddb/dbase.sqlite", :exist?
  end
end
