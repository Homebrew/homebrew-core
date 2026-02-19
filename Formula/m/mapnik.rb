class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.2.1/mapnik-v4.2.1.tar.bz2"
  sha256 "5828695831cfac09b5d5e660c6c0747f0f447c7356b183b26fbed3e220456b33"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "a0e77dbc25136b76fb979d6f90517a6f1730a98cfb8112c5555f23cf0f6ab6f5"
    sha256                               arm64_sequoia: "9a46c4ac818b301c0576eff83b5af0ce7e7f8b1bc12ba6c585c300c0ef0ccc31"
    sha256                               arm64_sonoma:  "a08fd81a277282b9ad5fe19d3a7bb4ef4d944e9716288138dc690c995ae2039f"
    sha256 cellar: :any,                 sonoma:        "7f64219e2fe9eace29ee064c77a79e1cb95498dff4b3460c8939a2e45e32917b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eaaed630c9f7c5cc37148a6bade7cbed83beabdbff25d8e447aacef965a40c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3402fc10a7358b9a916a7821325c6bc07a294e963741c7b8c3b987917124cc27"
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
