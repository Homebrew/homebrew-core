class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.4",
      revision: "5d155480e196fdc1b0627c7cc7044f09751069f1"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "71000dc22e3fc48801f6f8cc44f29d4f2e99563ba07808b00f20dd4f84d65fe0"
    sha256 cellar: :any,                 arm64_sonoma:  "7e3141b8941fdde78c99e500d02d23e67d033824ece3f1df0e8078925eaffc06"
    sha256 cellar: :any,                 arm64_ventura: "fda2abd546fcfe3798fca0787c7b2e48a00ecb79130e012292b857e21a96b5ba"
    sha256 cellar: :any,                 sonoma:        "31fff0fe0ad7d138c4f74572268b6fed81e426860b79e8c5fc99e595d18e0f30"
    sha256 cellar: :any,                 ventura:       "065206f79efa11f69ace22a620506fc521adf6e64026d05285ed62e9c8338206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8f071a2ee6a0d80f043ad9fbacd52af672002d8b8e49e4e7f4cff2297718e5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
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
