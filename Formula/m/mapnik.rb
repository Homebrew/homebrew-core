class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.2",
      revision: "5f327ff3c88d8acca7c5db15b598258eea363aa7"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa50fbcf7bccfda8776f66b624a66b0d8efa750afa93881403879c857bd26638"
    sha256 cellar: :any,                 arm64_sonoma:  "471145019614d7468a9eb6a823381af41b07a46619e3d06d9059cb539bcfe83c"
    sha256 cellar: :any,                 arm64_ventura: "b665c7179dca160990c2b21ba5fbac88ced96c9718591b8bf271c28d903053a2"
    sha256 cellar: :any,                 sonoma:        "82f415996ea6d244779903c718a1196338f3b9efe72ea14a0d64ca119484bba0"
    sha256 cellar: :any,                 ventura:       "ce2d965f33b79c612bbce543d3320e8f96e4d96b9ea5a4a5d1bf68ae1f84bc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "258fb4ed55478f0fbf50e74ef23ba9d2da75af065eb294849c613aadcffe7672"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@75"
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
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_BENCHMARK:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_CPP:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_VIEWER:BOOL=OFF"
    cmake_args << "-DCMAKE_INSTALL_RPATH:PATH=#{rpath}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkg-config"].bin}/pkg-config libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end
