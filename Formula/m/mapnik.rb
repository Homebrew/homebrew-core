class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.7",
      revision: "d9d4288bea04c5ef9925c03db353cf5f308e06ad"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9d5ebcc14c9a84221765e801d40660995bf8b96c14a80501bb9c255ecd4da97a"
    sha256 cellar: :any, arm64_sonoma:  "166f4149e2a884ba574a3067f095078ff8a43521169215fbd8d93eac36eaaf7f"
    sha256 cellar: :any, arm64_ventura: "95e92343254a18e5c6256fbfe1451d7f980771463380e4b711ccb378ce0c3297"
    sha256 cellar: :any, sonoma:        "6d266040e5a423a79a680c7b9dde632c7bb671d5ffd38fac01b7abab0ff4b5f4"
    sha256 cellar: :any, ventura:       "d776feb910e805a56172245df870d5b23e0139056383f47e0593bd378a77d410"
    sha256               arm64_linux:   "75a4d5fea53278343ad27f9140ec0b757c3be12f9a2f5b29f2075648d1215afe"
    sha256               x86_64_linux:  "a0c1b9b3542a7e0e11a158eb5b411927ca9e86c38160ed92bfde252b38bb54e1"
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
