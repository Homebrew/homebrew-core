class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a8714bd1c046892845fcc7e23132a410a62ba3d2711a287ff935f325b9be22c"
    sha256 cellar: :any,                 arm64_ventura:  "aa812c840dedd1852e9495b2b5fdef634650a021e29e18b4e8bc504bdf84d390"
    sha256 cellar: :any,                 arm64_monterey: "0e8e45406f3ea1bd87bf94916c1b3ea29c1df0f22bff0ea90e6934aee64c9ba9"
    sha256 cellar: :any,                 sonoma:         "0e88f9baa066992d9878096ab482c3d92517e74b4e0723de02423032fa2dc8db"
    sha256 cellar: :any,                 ventura:        "ffd6b9829025cf157cd7b3aacb02a1b8d63a3555277e4be8076fb09137fb4d70"
    sha256 cellar: :any,                 monterey:       "7f66ca2905681f4316e86eca8dfa094651243d18873a51c441e477d20bd71035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631d33bc0667ae43c76ff4ee00d4296d7bea115d831b990e65949b4341bab83f"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
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
    system "#{bin}/osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
