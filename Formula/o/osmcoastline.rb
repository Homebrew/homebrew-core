class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "217a446421753f6779411129b48f94d6f7ac323a9485428adc89ca27636b0e52"
    sha256 cellar: :any,                 arm64_sonoma:   "a0f8361692aaed6d584672777d535d8bc0fce0e55538ece93d140d1b3fa5df80"
    sha256 cellar: :any,                 arm64_ventura:  "e3bca51e41f0ef66d12b17b078cde994b9e3bd0735ba3c087eb03ff5ba6e8647"
    sha256 cellar: :any,                 arm64_monterey: "e033d67ef3ecfc55b6fc8a00c30c4a235865ab94709ed92169d12ad67f7fb762"
    sha256 cellar: :any,                 sonoma:         "54b87fc97bc9a3bd4937d05bd5c56899b32eb5d965cb9d518605656cb9e94ec2"
    sha256 cellar: :any,                 ventura:        "37efc15a7cdb9db548e418553f7e8fd4c1cdc904b86112db01ed59a12717fbf3"
    sha256 cellar: :any,                 monterey:       "d49649b9159889cdaa2ac3316ee6abf7c6f3e6ad218575ece8cef924eddb1d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ec7fa2e10d61afe24e05ecba6f66631fdf49d1b8e8e3855209a406f8ef340c"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build

  depends_on "expat"
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # To fix gdal-3.7.0
  patch do
    url "https://github.com/osmcode/osmcoastline/commit/67cc33161069f65e315acae952492ab5ee07af15.patch?full_index=1"
    sha256 "31b89e33b22ccdfe289a5da67480f9791bdd4f410c6a7831f0c1e007c4258e68"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    protozero = Formula["libosmium"].opt_libexec/"include"
    args = %W[
      -DPROTOZERO_INCLUDE_DIR=#{protozero}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.opl").write <<~EOS
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    EOS
    system bin/"osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
