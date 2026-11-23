class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.4.0/mapnik-v4.4.0.tar.bz2"
  sha256 "0f70e6eba27543b3e0b945da883856caaca91e3c75c3a2465f077e78ac089f2b"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "21266a094ae7dc37618a54baba881ee5afef0a7dca0619b7b79e1f122496e628"
    sha256 cellar: :any, arm64_golden_gate: "55f7ae87eb48214cc12635c7d99a9ed9052b9b92dd54cb8ae5e3b71c6a8da379"
    sha256 cellar: :any, arm64_tahoe:       "fc436f9a8b4087c25f6821556c167cfea515c54b44d72fc8829a2f50243e58cd"
    sha256 cellar: :any, arm64_sequoia:     "eaf18f21f130e0a06839b1863648615571c405d59ad60ef1beb9182a850a83c4"
    sha256 cellar: :any, arm64_linux:       "71b0b182b25d8849051a22abba504765fbba5a08f39ec6ea8c15dd0cffc2f072"
    sha256 cellar: :any, x86_64_linux:      "20344dddb40707cdb13d4d2ac09d41134724954e99e7579feac7122948bac672"
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

  deny_network_access!

  def install
    input_rpath = rpath(source: lib/"mapnik/input")
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath};#{input_rpath}
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
