class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.2.tar.gz"
  sha256 "b3776d7b3a534ca626525a42b97665f7660ae2b28ea57b3f53fd7e8538da1ceb"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 2
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a9f2faeb46acb862f38f5f6e435a160455cfff1eb4fcd11ccf80139d3347fd65"
    sha256 cellar: :any,                 arm64_ventura:  "537c4b219d812e0a65f1b83aed9c155987b9ba3685da2d798b7504c96be593fc"
    sha256 cellar: :any,                 arm64_monterey: "96b812beca68e53cad35856bb68ce1ce3f87d555659fe2c68b16d457b068d181"
    sha256 cellar: :any,                 sonoma:         "573f5b9d9dca499164b77712d2a47fad682f06b8fc6dc9363e96a2b489478851"
    sha256 cellar: :any,                 ventura:        "c6e7eaab95307bcd5a9d5ed8aeec521de3e26f536f4a1b5b1fd0532ba7b297fa"
    sha256 cellar: :any,                 monterey:       "12d833417be504c1ec72e197613929c34dbfa08a93e998bb94abee3736ce9378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba60221ce64d021d5c7f867a3c70f6898f643593cd72c180787bc9958aa2e56"
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
