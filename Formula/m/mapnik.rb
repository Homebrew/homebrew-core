class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.2",
      revision: "83c1f6b1a2f45a825e9d5764b9a6d33c907c4bad"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "77227a1ffab0e3675fd70f5b066540d3cf8e57ec6c514597ca882cac39f01db9"
    sha256 cellar: :any, arm64_sonoma:  "389a6b408eb754b857522fbd104eca72a4f41acf67bb0b2b3b1adecc81914eb0"
    sha256 cellar: :any, arm64_ventura: "424d4d5caee6ace0bd10b8bc2c4179b522735fe0b427f1add11cd94138ad2376"
    sha256 cellar: :any, sonoma:        "3fa20dd5e7888b02b5b5f429d8a6cce6d25964178b3035a2e3d9f27863128e37"
    sha256 cellar: :any, ventura:       "30751ba8f2afc2bf6456df4d8cac83671b9dbb511759b5cf39003e79b6fe7dd2"
    sha256               arm64_linux:   "80fc602bf72a60dab2b0c9503055e3c81c5c74bc6dc1b25f775c428e79ae010c"
    sha256               x86_64_linux:  "7acb700e17ed99585f2eb761ffda28b2a85f141fc8980ae939453e165809ece4"
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
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

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
