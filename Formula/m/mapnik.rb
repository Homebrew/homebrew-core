class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.3",
      revision: "e7a2bacb5d70f9c5fe0941906ce19137c0928522"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2f53c73cb863d507c63ba16d504cd889fdef52f305e56455ddb9a16a78da696"
    sha256 cellar: :any,                 arm64_sonoma:  "bc951c686a7cce9bf1069a47fb25f9e70be7e201c0929c0df1cc3d3e07bcbec6"
    sha256 cellar: :any,                 arm64_ventura: "2afa947389d44d8b746c4c597e9fe820f09affd07ad6509ddd9940af219adaec"
    sha256 cellar: :any,                 sonoma:        "344f16b532559a658cba16cb53c396b03eae00494531cddc1a2bec7d69e28a9a"
    sha256 cellar: :any,                 ventura:       "7754a4b78717da179701e04485bad90d6f7b0a83e3344a818b296cd6ed2dcca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73fce4531add2edd775a13e81a424f0b5e61e46eb92d61d50775e889a0ed8c34"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_BENCHMARK:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_CPP:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_VIEWER:BOOL=OFF"
    cmake_args << "-DCMAKE_INSTALL_RPATH:PATH=#{rpath}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkg-config"].bin}/pkg-config libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end
