class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.4",
      revision: "d4c7a15bc235b986fa80255cae0df9784c8b78c6"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1098d71b6866145145364446eeb8cb30b5846535fe94ed017fb45ff5cb3a2c49"
    sha256 cellar: :any,                 arm64_sequoia: "a82a08f6100507604c366e656a7bc7e6cc7e1f157fe79b71f2efee1cb05e28ca"
    sha256 cellar: :any,                 arm64_sonoma:  "8ffb2d1ef8fd8d069e360dddd9875d66207d51b40f76b70313c7abaa2a29db4d"
    sha256 cellar: :any,                 sonoma:        "fdad5a07eb4b99a875a64009c3368558b6403ed96b0151e33fe0930bd5011a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e768c0e46cb18221b5abcc4da5db508cfaa4981e6caa13205c8fc811d568b0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6d4bdca836df14b77543d556d8683f683c6beb099e3ab2542b5f65406ceaa7"
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
