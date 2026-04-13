class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.2.2/mapnik-v4.2.2.tar.bz2"
  sha256 "a530f03c2bcf1ea8f9e500a0dab7f8387f1a1eae3040a886c1547b3af86f5911"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "17461daa16a83cc1b68d83bddec019fe70f5ae3b2025dc96e6c452b609150856"
    sha256                               arm64_sequoia: "7eab01ac99e1e4d5033fe6b0820c765f4116abfcbf8dcf60629eaa83020533cf"
    sha256                               arm64_sonoma:  "d43b7a22d394246775470e7f7e1c04595950b398aa888733cc466bc578554b57"
    sha256 cellar: :any,                 sonoma:        "2d758a5fbfa96cab450ad2f598a7911c9ffd5d675f9a1021545e4c8d89ddd7a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578349d989d343e7334d1d816620cadf19364e359143034064444b4a50410c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773d9545c7adf7b00cddba30fc78af1ff692debb8e4388fb22f0742cc8e107b0"
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
