class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.0.tar.gz"
  sha256 "dae915201fd20848b69745dabda1a334eb242d823af600825b8b010ddc597640"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "84283eaa25f7674e42ea56ebe31801a6ac0539cbe44fb5e4c536983d8851766b"
    sha256 cellar: :any,                 arm64_sonoma:  "6787ed26f2608121ca8598b37b6d985e5fe4bb22c9718b7cdaa46ba439995fa0"
    sha256 cellar: :any,                 arm64_ventura: "b79c3b72a78f04a0db0e57c0241fae6b0efd2e8986021d5033a0aa098b411eb2"
    sha256 cellar: :any,                 sonoma:        "42540c9b23197bb53abd58aba435fca397e27daa792cc88275f75a495c242941"
    sha256 cellar: :any,                 ventura:       "8d6cc187d4e48cb9241939305ead3837778504a3d123fb7e2ff72b2d62b87af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c38d2aaa72371acfbc4a19d293514532c64559116b82be05406ed15359851a7c"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.13"

  on_macos do
    depends_on "gcc"
  end

  def python3
    which("python3.13")
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
      "-DPython_ADDITIONAL_VERSIONS=#{Language::Python.major_minor_version python3}",
    ]

    site_packages = prefix/Language::Python.site_packages(python3)
    args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: site_packages/"mgis")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import mgis.behaviour"
    system python3, "-c", "import mgis.model"
  end
end
