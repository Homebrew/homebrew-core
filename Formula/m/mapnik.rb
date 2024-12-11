class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.4",
      revision: "5d155480e196fdc1b0627c7cc7044f09751069f1"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab87cb3e793e69c53615683b53b3c6e365ac186acfc7be4251dc98df6eff8aae"
    sha256 cellar: :any,                 arm64_sonoma:  "cb9c05ea5dd2d47320bfa3907ea952803fc7a0be100262b8b45db557e4821614"
    sha256 cellar: :any,                 arm64_ventura: "60524efbf53df43e2f164aff1a2ea1316c8d6818cf64fdea9ac1b4cb6f9c52b2"
    sha256 cellar: :any,                 sonoma:        "596622beed73ac6675694cce66a9b1f73efbee6309937d01b529452ec2a6913d"
    sha256 cellar: :any,                 ventura:       "3e0672ff0984eb893bc17e4f56b43267942f3952a4b2f6b734e457c1f6122652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b20886682c82f94cf4f3372e9345f31f57980654d25d2db146c4fcdf0a215da"
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
