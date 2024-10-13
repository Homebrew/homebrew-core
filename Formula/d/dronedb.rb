class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 7
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3d3142c0a755873b372896657872fcac7e3a91a40f8576ffa5faf2a59630737"
    sha256 cellar: :any,                 arm64_ventura:  "a6ee78ffab0b520948410840bbff68e931a66b8c0a34d052c8179709ecda39e0"
    sha256 cellar: :any,                 arm64_monterey: "ca62fb9f855399d505c942c955240240528b83ddb502c34e1ac521b4fee3ef27"
    sha256 cellar: :any,                 sonoma:         "609a84ef6f38adb0121c9a03f152838d40d4022e3cb0fbe23ffef069ab180aab"
    sha256 cellar: :any,                 ventura:        "9f10917f8113df8ba4304b9ec4a8f5310aeb1a02800c54e133f213ef5c8e05c3"
    sha256 cellar: :any,                 monterey:       "5c98ab4154799105787de9bb8c20282396ac3ac2792ecfd4cad761454340cdf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c8fc899bf57bd4a80ad4f0673b4e24ef9143d903c89b274e80bf3b5c29ccc4"
  end

  # does not build with pdal 2.6.0+, see https://github.com/DroneDB/DroneDB/issues/383
  disable! date: "2024-01-19", because: :unmaintained

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
    system bin/"ddb", "--version"
    system bin/"ddb", "info", "."
    system bin/"ddb", "init"
    assert_predicate testpath/".ddb/dbase.sqlite", :exist?
  end
end
