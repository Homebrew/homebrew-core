class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "3a76ed8c8481e5499c8fedbba3b6af4f33f73bbbfc4e6154ea50fe48ae7054a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc16d9bbd13a4f77009a7bb0c87a2461dbbf0f004a57676da70803435096cb00"
    sha256 cellar: :any,                 arm64_sonoma:  "c89acfaeebd5e4661327ab2abb42ff5407365f251a052b97b80f3a4fddd266ac"
    sha256 cellar: :any,                 arm64_ventura: "3c08b87fc5b15d8a778ed08c9d7cb0dcfa5935413e5a85a2a3170024118b3a78"
    sha256 cellar: :any,                 sonoma:        "9323e20db733822fbeafb7a4042009e82a57f65e94c78855e647c9b0df01bc50"
    sha256 cellar: :any,                 ventura:       "13ca3a9c33d469ed3a7e261ac9376d732db372f4fc7a20d06533fd3374356559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a1fd8484e7c3354a892775b7e9d6a71c6f4f46dcbec82fa7f6babb3e5407d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ab937e69ae5ff226d3528cacbf640b3f486e311d438c02f8e40cd9202a5e18"
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
