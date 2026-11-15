class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.3.2/mapnik-v4.3.2.tar.bz2"
  sha256 "1858a9d57f4d2007d717ea84af23bcb32bd984fbc635426b79124fe9f7a682c4"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6193dafbec13a3f6c1b7e82edb657d0a05278ead1e4aa280dbb09d30e24f7f58"
    sha256 cellar: :any, arm64_tahoe:       "f1224f153b89c4a0a653fca20de35b683bcad3282fbfbef14c05ef80ecc1da83"
    sha256 cellar: :any, arm64_sequoia:     "047a1df58d74b75e3d766286d138704fc396b0d4738c5a934ce7e70a2771339e"
    sha256 cellar: :any, arm64_linux:       "92505b642f41fdbcea7f5379e447162fac176660908a6d9ddec2a1adb9742aec"
    sha256 cellar: :any, x86_64_linux:      "41e1ba7f516550eb5185505ae25a1f16bc6f52270cd0619033007f472a1c7a3b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@79"
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
