class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.4",
      revision: "d4c7a15bc235b986fa80255cae0df9784c8b78c6"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d80149acc2fac0817ca8e978db586c4f8edaf7e05d8a5bc52495f706e118d13"
    sha256 cellar: :any,                 arm64_sequoia: "c9626691112c65a402b1234f85517961f8e6fd2c281148da993d94abe299645a"
    sha256 cellar: :any,                 arm64_sonoma:  "f48c7dd37adcf6e560ac19b24551b168b66c475cd98779c4be5d86a23c2b8d7f"
    sha256 cellar: :any,                 sonoma:        "1c2545939067150d70c1a4d3214bdf1f9ff625debd968bf5d67808bf7b4ae240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8923ab55cc421e2793259e9cfebb64b87a0b5c71f0d51c20f6c30a4dfa08a3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e51811088aee4abb8fa5f467908b45ea629b5e4ccf85108d8b40c965eae135"
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
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath}
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
