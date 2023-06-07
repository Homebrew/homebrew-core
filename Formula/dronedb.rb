class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 3
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2fef614a4bdd8f9adfc3f7ac1187ce7a4ba37eec53f401468f7eb05d592e0c44"
    sha256 cellar: :any,                 arm64_monterey: "edd22966d7a62c2b8b65a54876a597360003d83408dbbb8b76f9556d5cf7ff9c"
    sha256 cellar: :any,                 arm64_big_sur:  "f65259fdd921171ad579f4da450f4e74600c1b1abe4b953fcc5871432cd894cc"
    sha256 cellar: :any,                 ventura:        "1868a493701c0b4b30cfb517abc6408fb278c88c4e5019bf1141d725b8c3b13a"
    sha256 cellar: :any,                 monterey:       "2afe4dd4f029621045cf7c5a7ae6952d2b10d895c3b605117f46fd227becdc79"
    sha256 cellar: :any,                 big_sur:        "6229a39e1fa119aba0d529fcca44ddaae02e91fbbf9761e23a98773ad624373d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d112218dfb122e57372c11f3b32f976d1f436eda2e2531ae4e85303fe56d316"
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
