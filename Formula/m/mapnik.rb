class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.5",
      revision: "ad6a7507d5ce0484e85da80ad2a27adb1e15b101"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "43a72bb30d5ab436a720bca830646448bbd6ae3cdb0a4b227ea845dfdc0c711b"
    sha256 cellar: :any,                 arm64_sonoma:  "68a4a655bc234a8b3f3112de15bac768cdec91606cb772c79e77da669c5043b9"
    sha256 cellar: :any,                 arm64_ventura: "59fcaeb40aeddafb1e6d9e028e8c1bc79bef4e8d5be788798166fb0a0e862418"
    sha256 cellar: :any,                 sonoma:        "7755782671f7cb9292a1734fcf95148d3396a5d8fa458fbb9a9e440c9f246387"
    sha256 cellar: :any,                 ventura:       "b8deff181ae681eb06bfb091e91a47d05e718d9f76106d3ed9094d9c004b6bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c6a4b3de0fd83d7f53f2bb90aaaeb61543074ff815b082c1c2e58563bb6e636"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  conflicts_with "osrm-backend", because: "both install Mapbox Variant headers"
  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkgconf"].bin}/pkgconf libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end
