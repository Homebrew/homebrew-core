class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.3",
      revision: "838a1730b239c64b49bc4144a4165e093a6d5bd5"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0dba27bb885123fcf851c103cdb3d6986ca9971278ece39548ff134fa3d32787"
    sha256 cellar: :any,                 arm64_sequoia: "6347f7a8f30fcc7987bfbad1ec2b9b86ca9432215f14286138ae63f451fca2e0"
    sha256 cellar: :any,                 arm64_sonoma:  "5379e002ae90c248fe0661b9e62fb5213bb2ad9beb5f97b0fada2a2819b10e0d"
    sha256 cellar: :any,                 sonoma:        "ac9ac89f452ed7865c315e6aa0146dcbfccb1b16a983fbe10443850f89acf51c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ca52379f212b6ebb0ac3da870d3ca24e6bbfe02222993daa61b2c076391d1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abc3d2b6bbdfc29f5e536e7d1588beb8eab726ddb532203e9142da07d7178bc3"
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
  depends_on "openssl@3"
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
