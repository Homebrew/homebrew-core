class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.0",
      revision: "85801bd4028fa1cbffd9f7de4e2458bfc55e44bd"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "76cd0f41910f491fa38de43b7514efe0225ff00b0f67d0b02ade7abc5033dc95"
    sha256 cellar: :any,                 arm64_ventura:  "f91329d7796c0fd584ae3fa8bdb98712908fe6a7da2195b92e47bf1297dc0ae5"
    sha256 cellar: :any,                 arm64_monterey: "1b2b3135ccd3ab978ab749e4c7d1168d9b9bef3160486bd8a7c1b7096fbc6d2d"
    sha256 cellar: :any,                 sonoma:         "38044de9396c8887858ff6fdc29ffe8d2c998d7ff4c8ffc91232a734478256f8"
    sha256 cellar: :any,                 ventura:        "0942989e458ea66f9a68848c69717236b75e61bf03399b0c296533a63a152d69"
    sha256 cellar: :any,                 monterey:       "15a786db5e5ab087fb1ff316324bcfa9543937012f245871d7f98728948e4c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36a3e2447da8d0a3071e5ef8960595a06828147dea5e54b9af4f9b627c8dc40"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c"
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

  fails_with :gcc do
    version "14"
    cause "Fails to build with GCC 14 (https://github.com/mapnik/mapnik/pull/4456)"
  end

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
