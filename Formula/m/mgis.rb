class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.2.tar.gz"
  sha256 "b3776d7b3a534ca626525a42b97665f7660ae2b28ea57b3f53fd7e8538da1ceb"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 3
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b7779b3b5c38db9f720dfe50cf812955434ff9fa6eb9b42edb47583bcce28c45"
    sha256 cellar: :any,                 arm64_sonoma:   "73c148a736218658862b6627cd7c2864bc74f01afeaa7f948f4af7e0bc991c1f"
    sha256 cellar: :any,                 arm64_ventura:  "488f7e70c16abb8b4c6845717cda7df904f2d1d757614dfdd63bf80dc6d1beb5"
    sha256 cellar: :any,                 arm64_monterey: "51acb9671ffeacc21b644d28e0fc5f7f9b874b1b928e06f8d93de061d013043b"
    sha256 cellar: :any,                 sonoma:         "edd070e94b3729e3fb0313846ed723cfe12c8e9139dd63f2e52ace7c1c82a3e4"
    sha256 cellar: :any,                 ventura:        "ec42419ee95dddba6b674c1f73687543d51dd07f938696cb6830d1ce2187c515"
    sha256 cellar: :any,                 monterey:       "a4ae2c41254776a40b86c3a224369c5dacf2c8bc4515ff45f769e3957d27a24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ffae790702d03708dde3d9465844e67f576d50f92b9e8e0d25c88815678797"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.12"

  on_macos do
    depends_on "gcc"
  end

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
