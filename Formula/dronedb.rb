class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.11",
       revision: "f9f7d50c1f2b49072e4046cb2bd2d9fd67066252"
  license "MPL-2.0"
  revision 2
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4ec051353b74298355daaba90ebe577f57ea963bf5bf4c23444ed1a6f42d10d5"
    sha256 cellar: :any, arm64_monterey: "e12baf23f98b6f518075e9e5fdf9b1a4a77b9034810ec1287ac61a92505460c0"
    sha256 cellar: :any, arm64_big_sur:  "0c10bba6db56714575a9ff6bb1bf4d0468df253f6359ae9b5eb55b46651c4383"
    sha256 cellar: :any, ventura:        "ef4fc0c0d8497376e8fdb7334d13f17517b08c04b69d14cfd58907254a3c9fdb"
    sha256 cellar: :any, monterey:       "928b227318b74ca87b0f9fe93955f2743b1c755d61b6e8ac9047a26cf466caf6"
    sha256 cellar: :any, big_sur:        "8f8090e74b88110494e6e1bea2483822bd0c030d55d0251e431f529172570fcf"
    sha256 cellar: :any, catalina:       "690e1e2686f39e82a64d7a1a7b33c599fde943ef86e99123b8aa90e8ad8c3f3f"
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "libspatialite"
  depends_on "libzip"
  depends_on "pdal"

  def install
    # Avoid installing conflicting vendored libraries into Homebrew's prefix.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink libexec/"bin/ddb"
  end

  test do
    system "#{bin}/ddb", "--version"
    system "#{bin}/ddb", "info", "."
    system "#{bin}/ddb", "init"
    assert_predicate testpath/".ddb/dbase.sqlite", :exist?
  end
end
