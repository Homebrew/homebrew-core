class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.3.2/mapnik-v4.3.2.tar.bz2"
  sha256 "1858a9d57f4d2007d717ea84af23bcb32bd984fbc635426b79124fe9f7a682c4"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "000b4103fa866d4730b463eb9082dc25a6b6f2d4476c5ee1ca1f6eefdef7c039"
    sha256 cellar: :any, arm64_tahoe:       "a66036cf2d723b3fea6f29eda1de9e88fe455d191f059ffb834b5155cc920b45"
    sha256 cellar: :any, arm64_sequoia:     "6a7ab3fc095a116df911bb8aec50ed9b695dd2c1b55d5911c3d26ca7897273fe"
    sha256 cellar: :any, arm64_linux:       "0ae073047eb675f7ae2d8942903bf7eb71883d9e1257cf1aab2c4b07b41da213"
    sha256 cellar: :any, x86_64_linux:      "337cf84aa6dc5a48681e5d1daff403d04169849347a53789d8ddbf565b631bd4"
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
  depends_on "openssl@4"
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

    # TODO: Remove this workaround once either:
    # a) CMake in mapnik properly handles C language requirements for proj OR
    # b) The workaround is no longer needed with proj > 9.9.0
    #    Ref: https://github.com/OSGeo/PROJ/issues/4862
    inreplace "CMakeLists.txt", "LANGUAGES CXX\n", "LANGUAGES C CXX\n"

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
