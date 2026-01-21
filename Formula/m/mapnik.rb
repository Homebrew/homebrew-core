class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.2.0/mapnik-v4.2.0.tar.bz2"
  sha256 "22299a06e466b1a32e6b1bfe5aaa5194289f94d5cdea7e18e631c1de4de785fb"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "f43169902fc168e5f4f39880f3cd7b706a07c83920b0fa14d02feefb0343c184"
    sha256                               arm64_sequoia: "117830d1281cf7a9fdf5f48c784bc9f1165126b16ae864d09aaa0e0d51003865"
    sha256                               arm64_sonoma:  "44f3bf5870bdfbf872557008b130a33924c27af343e0b49460b673945c7e1df0"
    sha256 cellar: :any,                 sonoma:        "62cb63357c8b633a16900ace42b5bb0d708726bccf40267db53b74621aa413d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d83840bcb15ea2b37c40a2a43c8fdec7b31b0f20fa51150aab79bb5c405bc92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01032bc0c51c3b879932dee92dddd998d073d2cdb33bf62eb1cfffa0ba175fed"
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

  uses_from_macos "zlib"

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
