class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.7",
      revision: "d9d4288bea04c5ef9925c03db353cf5f308e06ad"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "31afe41c814f15e1b8d9ae122356c4a8028de1988078483725c96b3ff2df80fa"
    sha256 cellar: :any, arm64_sonoma:  "fee7f600c776a1f9251aa82340fcef5a0efad9d440165cb962d55e30b558243f"
    sha256 cellar: :any, arm64_ventura: "4934916118f81225aef00bca0c75c940dca8c570cd96d1e06f26e2b5badab497"
    sha256 cellar: :any, sonoma:        "4d00c9c5ad4e5b7c3e5570f06a821e7209051feaa4dc0004bb685e8c412ef535"
    sha256 cellar: :any, ventura:       "c45f5b9cb120f7a53bb55a38dd672e37dd886e539730fa7f7999d16532d62a56"
    sha256               x86_64_linux:  "248009b9885c44b21193d3bc4225dbf6bf01903088c13218f86598562bbd1c7d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
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
