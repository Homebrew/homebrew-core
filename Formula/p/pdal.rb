class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.7.1/PDAL-2.7.1-src.tar.bz2"
  sha256 "7769aaacfc26daeb559b511c73c241a5e9a2f31e26ef3a736204b83e791c5453"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/latest/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d369065f506a098721bd7e00c2a8f0ebf6e01a7d6facaf49a14e8be246ba4a87"
    sha256 cellar: :any,                 arm64_ventura:  "2de77facd3be98899c86ece118ee9f0cf2d936085f6456e84ee489f3c9cf057d"
    sha256 cellar: :any,                 arm64_monterey: "a9df30529d426d47885e8aa24dab47282f4f9c83c69c79ef0a0a4e600ca4226a"
    sha256 cellar: :any,                 sonoma:         "96e66792a4d2d0418759506854fde73ce0ab1a8ed890f317280adabc0dbd9fe1"
    sha256 cellar: :any,                 ventura:        "c6d596fb8ecf669ef626c0ffedc50da150f18c957e4f43c184a6381be89c9a79"
    sha256 cellar: :any,                 monterey:       "2f3c716e0946cc886a16fc7e68afbeefbbaae39c37aa9c7a3567246c4222d529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12d179a8ddf24135ccf4edd54929d6fa591a0e4a26d0daa7209f67f1c042ee3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"
  depends_on "openssl@3"

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    rm_rf "test/unit"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
    assert_match "pdal #{version}", shell_output("#{bin}/pdal --version")
  end
end
