class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.7.1/PDAL-2.7.1-src.tar.bz2"
  sha256 "7769aaacfc26daeb559b511c73c241a5e9a2f31e26ef3a736204b83e791c5453"
  license "BSD-3-Clause"
  revision 2
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
    sha256 cellar: :any,                 arm64_sonoma:   "78faca61290d969153673696ed76b92a84338724f95ca6c744dac7a6db0e2cb1"
    sha256 cellar: :any,                 arm64_ventura:  "61ed1f667ecd1cfb3414f125d5ffb9515d8862bcbce79226abadcd5d35ee3cee"
    sha256 cellar: :any,                 arm64_monterey: "d42840c028a0429a615e8cde87760105ce2f66579d6a45d3ccb28a205c2f41d1"
    sha256 cellar: :any,                 sonoma:         "a7ea7ff45c148c9e38d5d343cdc29c662c1b3ade3c3a656420400fa6919be3b3"
    sha256 cellar: :any,                 ventura:        "e641444bffa6f91e64e90e34c88c4f19502bd36ce9e4ba69c8a1131e5b9673dd"
    sha256 cellar: :any,                 monterey:       "9233efc48e140c65827bc8fa349c78ea741433e7e02f81c834158407ab292e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3adb78553c739e806602f7ed6d2863fe907aa6f8e44cb2e38f72c1151b349f8"
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
