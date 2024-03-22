class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.2.tar.gz"
  sha256 "b3776d7b3a534ca626525a42b97665f7660ae2b28ea57b3f53fd7e8538da1ceb"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 1
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2bd24d25f6466447e6bde81d60d882ffe2c628afe20dba8e79bdd7cb97ec61bf"
    sha256 cellar: :any,                 arm64_ventura:  "3e5fa82b99d16d95cc4cb14bb3693a98d8062fa40b1d5304c14c2244dd94b55a"
    sha256 cellar: :any,                 arm64_monterey: "09af9fd2b65e9b0a7973675a5dd19432e3e06a383a7982cd20a61e08816f77b1"
    sha256 cellar: :any,                 sonoma:         "d3cd13a7f563f1f03d93df3ba8dc5f35b07cdade9a27db2f577d28faa0577ca4"
    sha256 cellar: :any,                 ventura:        "a824eef673ef10b82c7da248878d986f947b6fc46951a9ac3e17d5d8caf414c4"
    sha256 cellar: :any,                 monterey:       "5a80fcac0d29d5080dd5ae89c7d5d9bef4757bf817dee35f2f1c4cd319137b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54728d7b513b611cbe8e023fc9de26193c7f2bf09f818e0aef03f63afbeb966"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

    args = [
      "-Denable-portable-build=ON",
      "-Denable-website=OFF",
      "-Denable-enable-doxygen-doc=OFF",
      "-Denable-c-bindings=ON",
      "-Denable-fortran-bindings=ON",
      "-Denable-python-bindings=ON",  # requires boost-python
      "-Denable-fenics-bindings=OFF", # experimental and very limited
      "-Denable-julia-bindings=OFF",  # requires CxxWrap library
      "-Denable-enable-static=OFF",
      "-Ddisable_python_library_linking=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import mgis.behaviour"
    system python3, "-c", "import mgis.model"
  end
end
