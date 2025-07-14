class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.1",
      revision: "bb6aaa0cdd9f54cd08426e9c0fe051bc7a25072c"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a8a18dcd2aff757d8039104c1eeeff563c50b75beba3d0cdefd0d42cb495509c"
    sha256 cellar: :any, arm64_sonoma:  "35a80d8fb5c9598e754761f6179fee5a29587a58636c718f4f49c618cdb0d422"
    sha256 cellar: :any, arm64_ventura: "bbc76eab5faedaad2b735995fc68b889c569065042428966e7cb2c4adeb79118"
    sha256 cellar: :any, sonoma:        "01cae45f2d7dea3a35bda47e178b411f8143f8263ebf15ab7ce37f1ce5d48400"
    sha256 cellar: :any, ventura:       "ebd5c3b128627cdddc145760edb09956520e8ec631629ed5da1683a4747277a2"
    sha256               arm64_linux:   "36be1b0ffdbc17b846e953b52e56f8f48f55eed2deb934a61b1807f9d4d14a5c"
    sha256               x86_64_linux:  "18d0ae221b4a8b08eadc0ec1c17186e662cfdd2f6afd81b5914299a3fc6a3c04"
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
