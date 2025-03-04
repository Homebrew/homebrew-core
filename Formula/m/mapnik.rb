class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.6",
      revision: "e07ea00deff9a1b2e7e3498b83d7315fc968ae67"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a93613ce197ffec6ca8dbd507d2436ad40e2bd13a49c489fb3259fe31b6b809d"
    sha256 cellar: :any, arm64_sonoma:  "f1bcbfcf66ba53415cdb53771b54d4bc57779dc0ade25f8fe2ba18a58ce14b59"
    sha256 cellar: :any, arm64_ventura: "d076a19b45c4ca57f49990a71c0c9d502ad2689061c91a81e9b19e3066ee818f"
    sha256 cellar: :any, sonoma:        "50e7a75ce05c480af0fb88fdf1aa88cba924dbee3efa8958ad28c81b505cad61"
    sha256 cellar: :any, ventura:       "9f4a92287270d28f9c43ec49f2e88715722e17085f56f5b207802c07c4938efa"
    sha256               x86_64_linux:  "3344587526fd3255474c51501d6c6ff853debf75ed8e854bce90959df3dba400"
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
