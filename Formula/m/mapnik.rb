class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.3.0/mapnik-v4.3.0.tar.bz2"
  sha256 "cec8c2bf2fd5f46be0fdb77469761a3ba1d51bea7b3c16b91875e9f89867d141"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "2cf57467d0bcd2e73d4edef4db84b626bdd934e3e455d9a70fbdb7cd18b3569a"
    sha256               arm64_sequoia: "79ab2ac708dd1be0cf8a0b21cdfcc10d4f8483a050f95671ffae4de58ad8619f"
    sha256               arm64_sonoma:  "4960f69f6a7efcccb4cdd62bf692bb8ca7823ec55905cdfe204603b9710e872c"
    sha256 cellar: :any, sonoma:        "dbf5eba54315fa3eafdea977bfe4e99a35cdd62a8fb26744e02ee3242b414b29"
    sha256 cellar: :any, arm64_linux:   "b186311caf300288f1ce5751458c9b5ed8bacb273938313b77f2af8fd7dfe98d"
    sha256 cellar: :any, x86_64_linux:  "b7cf806b1df3616695de3bb037cb7492cdcf1ced628befb068d2c259889fcc78"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "protozero"
  depends_on "sqlite"
  depends_on "webp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath};#{rpath(source: lib/"mapnik/input")}
      -DUSE_EXTERNAL_MAPBOX_PROTOZERO=ON
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
