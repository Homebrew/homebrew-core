class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.8.0/PDAL-2.8.0-src.tar.bz2"
  sha256 "8a6d7646912a4e7a382f06451b14a1f5f2e8aa4e0b391dc91c30701222198b77"
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
    sha256 cellar: :any,                 arm64_sequoia: "a25042b13f64a56887847c637ad85aab17c4ce08a19c06060ce345f5e6bd689f"
    sha256 cellar: :any,                 arm64_sonoma:  "9671dee48a02a2c78c165396c216baf6b475195d8f9e5edc7a0d93d9830555c4"
    sha256 cellar: :any,                 arm64_ventura: "7b3a5b812869b67f33d1a9b654ff94f32d3f04c49cbf96612918aeca1633f631"
    sha256 cellar: :any,                 sonoma:        "d07fb31b3f5ca9f2508aaa5316d11ce7f4882b51a6a660fb34b7035750e4da34"
    sha256 cellar: :any,                 ventura:       "e6157fa9e4d634dc0b792798acc7268aa6071838ac38093edadb0536219913bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0fc029b89a567e31ab49e4b6828e7450d09543e1179a504f94d6d0498745e33"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libgeotiff"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    args = %w[
      -DWITH_LASZIP=TRUE
      -DBUILD_PLUGIN_GREYHOUND=ON
      -DBUILD_PLUGIN_ICEBRIDGE=ON
      -DBUILD_PLUGIN_PGPOINTCLOUD=ON
      -DBUILD_PLUGIN_PYTHON=ON
      -DBUILD_PLUGIN_SQLITE=ON
    ]
    if OS.linux?
      libunwind = Formula["libunwind"]
      ENV.append_to_cflags "-I#{libunwind.opt_include}"
      args += %W[
        -DLIBUNWIND_INCLUDE_DIR=#{libunwind.opt_include}
        -DLIBUNWIND_LIBRARY=#{libunwind.opt_lib/shared_library("libunwind")}
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm_r("test/unit")
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
    assert_match "pdal #{version}", shell_output("#{bin}/pdal --version")
  end
end
