class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.6",
      revision: "e07ea00deff9a1b2e7e3498b83d7315fc968ae67"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f11df471bfb2652463b8e3098ee44664b51cb312882a47a2ec219f71b4d24f98"
    sha256 cellar: :any, arm64_sonoma:  "0f97d722309a67c7afcb2a3caab29b620196f8c1b74aba52a1ef0536d1f00602"
    sha256 cellar: :any, arm64_ventura: "77e49e22055920e24b9db5fd5846c45d2919b9635dade75c3e15351a70fadc6e"
    sha256 cellar: :any, sonoma:        "003c919c499ddcc1229df26620c4caea74fc88fc9d7ea1b90e9c9c653be67ee3"
    sha256 cellar: :any, ventura:       "d58bfb89f35843c12d473f15766c0267fb9abfa605c871f919c76efda064c433"
    sha256               x86_64_linux:  "b06f540c7a848079cec367d14bc051d835d8f3d4561b009804afb77a3f008800"
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
