class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.7.1/PDAL-2.7.1-src.tar.bz2"
  sha256 "7769aaacfc26daeb559b511c73c241a5e9a2f31e26ef3a736204b83e791c5453"
  license "BSD-3-Clause"
  revision 1
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
    sha256 cellar: :any,                 arm64_sonoma:   "fc02eeb18ed45aa01bba3d7e3790e5366fad46411ec5567a403776f073278b61"
    sha256 cellar: :any,                 arm64_ventura:  "17a0eabf12aa1273f7dd6c57241625c1d0bd71ec7999aa2dbb3194d928efbd63"
    sha256 cellar: :any,                 arm64_monterey: "2f1d3589fc26a09f11462ae563794c4389c086b02390dc4902a1f8cfbc6ee4d5"
    sha256 cellar: :any,                 sonoma:         "24e0d4e078d82544ad90dec4c614e095867a545200ae186dff6cb89295715185"
    sha256 cellar: :any,                 ventura:        "5437a20f313b43183dbfe8f4303f596b286ace6bc4dfb8749d0355147b508e23"
    sha256 cellar: :any,                 monterey:       "c5b967deec6e8850d8799538ccd95aca17bb959fb0b6b40f008c4c59493f07b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e852b34a7ea83c966887b9b461c7ec4af931650f02e2ec25e3962f3f4e1eac"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"
  depends_on "openssl@3"

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

    rm_rf "test/unit"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
    assert_match "pdal #{version}", shell_output("#{bin}/pdal --version")
  end
end
