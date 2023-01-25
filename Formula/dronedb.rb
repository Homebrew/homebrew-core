class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 2
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8067f8237f61d2f1a10fe728f48ac80f0f877d9cbefdbaa3dc3af7bb7a7d2e9b"
    sha256 cellar: :any,                 arm64_monterey: "81176e069ae235c569e8adc276a06672791f978c51222f89d1dbbe71063b2896"
    sha256 cellar: :any,                 arm64_big_sur:  "5dce0bc248e72a61d66e737d46a687495df2a1bea710672e71ee1fa68b92b01f"
    sha256 cellar: :any,                 ventura:        "c2bed40cc8934adc9e5b5eae973a4d55200407d9f4d812448791ddaf6ecfbaa2"
    sha256 cellar: :any,                 monterey:       "5b182a4a4429b0d15dbf5a6ec3af4574f383ba972d7ffb542a7bbc8a7fb0e77d"
    sha256 cellar: :any,                 big_sur:        "7f95359441f7baeb55a8c654bc62c3cead8e16191c82ebcd1b6d3e18375ca7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b100650b914f9587331f2b807fbd4afc7a1c7439bb526899923b8dda9e380a"
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "libspatialite"
  depends_on "libzip"
  depends_on "pdal"

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
