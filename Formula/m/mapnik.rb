class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.3.1/mapnik-v4.3.1.tar.bz2"
  sha256 "aadfe037a8fdf7524bca7d72594ed9783c7047b7a53c6cf2e767f6e802d53edd"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8e50afe8a3bd50601577181997bfd2aa9fc70a5a929b3c6c7784774f89088fa0"
    sha256 cellar: :any, arm64_tahoe:       "99db6651491ca3a306f61d5cbf6bca857f5031e1c13e982cdc72b7d9e5c76c80"
    sha256 cellar: :any, arm64_sequoia:     "64bbeca5e052b964c53ec208f4b5119c78d2270ded7f13d5682822baa0861cbd"
    sha256 cellar: :any, arm64_sonoma:      "f27b4e8159b53d0f6ce40cb21e1ffc53adbb423b10c1d236614243af02cac79c"
    sha256 cellar: :any, arm64_linux:       "f2c15b9d4d17f09a399172b6461b8e1d7b12a83812d84c71f237937429254c43"
    sha256 cellar: :any, x86_64_linux:      "79ec3d1289b7955084669787f0d1a5cac52f2eb932d0d796af5002bd97ded36c"
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
    output = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end
