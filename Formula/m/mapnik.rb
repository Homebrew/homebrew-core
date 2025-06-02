class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.0",
      revision: "203d6f01b0a64e445e8df15d2cb2dfbca8f1089f"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4489722afc28bc0136766959c977b53d1c1350c0cb8736fd1953e46bdf7e8a09"
    sha256 cellar: :any, arm64_sonoma:  "d9de0b20f517923050d3e3094ac4cdf264d8136e93d75b067ce430e569ca3185"
    sha256 cellar: :any, arm64_ventura: "efefaa28ac60c12d8bfb0a138de9915bd4bf3d6debc51e250410d3deb2662efa"
    sha256 cellar: :any, sonoma:        "d8e85f5f8c217631b0a3b210b3a3d55f87bbc9f6d0a2ee72c14399aa7071cb4d"
    sha256 cellar: :any, ventura:       "369c83c4ca6cab4abbb09315a29f452251712ebd24e41f2388321c6c169f7785"
    sha256               arm64_linux:   "86e8ec32c92569f4b9943f211beabfea4abbde6894ee80409a157152f6cf810e"
    sha256               x86_64_linux:  "2bd231fe0a1652182bab271fe06d839c0bb67f86f286321ef5b3fe604eaff906"
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
