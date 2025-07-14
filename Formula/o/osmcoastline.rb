class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "3a76ed8c8481e5499c8fedbba3b6af4f33f73bbbfc4e6154ea50fe48ae7054a9"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c35ab027223ca2ea5a8555eb16f6f28e3b08dd4b2041d4796331391a1458a5f7"
    sha256 cellar: :any,                 arm64_sonoma:  "4792911cf6b33270e68cac5e9bb1810dff2a0869410905ae47c1978a5683e7b5"
    sha256 cellar: :any,                 arm64_ventura: "a791ac1186a07fb44e973b7d08e2db4d73694e34d45aac133ebf399900e72486"
    sha256 cellar: :any,                 sonoma:        "aef43094262f2b19ef4fa3c689ecfa6a51064e8ecddd9fda6d625cb690a6b0a1"
    sha256 cellar: :any,                 ventura:       "51f97203e6f852e9ee35a14a98ba7d65f8aa1dea74a5711123e897e3e54eec8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfd02b5ffbd8862c4c8f753c921c6db4930f64740883e9c4bd76ca0d7a89e1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512cdfad91e7e710a01e2f387d73661032fb267fc90c6a51131953c184956bb0"
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
