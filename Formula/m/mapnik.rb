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
    sha256 cellar: :any,                 arm64_tahoe:   "72ea3f1efc10fa8e83d05774db183a3f5082a1f34483d34b9e55f5c260625ff2"
    sha256 cellar: :any,                 arm64_sequoia: "0a2cd6c98d6e64298e0916480a8c59d671db9a62b3d63bba1366ad9c53730cb8"
    sha256 cellar: :any,                 arm64_sonoma:  "e0da3343af09b15c403f10b7480a05b13494f3d568081741fad2babbde84c6a8"
    sha256 cellar: :any,                 sonoma:        "0efa0d397fcfc18bc32eee5accbd0354739839184b6a487f4a31fec0bd1978d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45cda7b2a839b89f9614a91d12d6015b075f8b87caedb1a86a56286ff7b75e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead24f7cc3534e1d89cce9e88c24791b58f2052f2e2be66445603f15512b9ead"
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
