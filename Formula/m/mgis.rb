class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.1.tar.gz"
  sha256 "61afae1a367dbb150b24ca85f042efb15a77184a54a746f11c08d9b7cb9e94f3"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74c7f1e27791371b8e7c2014d3b1da8f7293ef0d3f6dd81e5bab33d43fb41cfd"
    sha256 cellar: :any,                 arm64_sequoia: "6dfe278f99ca5f7116b2c526e8b316390fad47674f299814be2a7d8594ef9b40"
    sha256 cellar: :any,                 arm64_sonoma:  "f1333cca1bf8e8686419db05e9a42697bc086c5b82fb40cd83c8ca3355e3648b"
    sha256 cellar: :any,                 sonoma:        "0e6b9dbe76a216c54c3844fd5ddec1bda82768074d85894a0eefc9c09f4b1377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d509f8a2b1594e5baa6f14f365cd04d2c508c69c6452d6233a9b077e71a877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424ecd722ae433941899b73dc513fbabe4ff0631988cd5e8336c56cec5c5fa1f"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build

  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "tbb"

  def python3
    which("python3.14")
  end

  def install
    args = [
      "-Denable-portable-build=ON",
      "-Denable-website=OFF",
      "-Denable-enable-doxygen-doc=OFF",
      "-Denable-c-bindings=ON",
      "-Denable-fortran-bindings=ON",
      "-Denable-python-bindings=ON",
      "-Denable-pybind11=ON",         # requires pybind11
      "-Denable-fenics-bindings=OFF", # experimental and very limited
      "-Denable-julia-bindings=OFF",  # requires CxxWrap library
      "-Denable-enable-static=OFF",
      "-Ddisable_python_library_linking=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
      "-DPython_ADDITIONAL_VERSIONS=#{Language::Python.major_minor_version python3}",
    ]

    if OS.mac?
      # Use -dead_strip_dylibs to avoid linkage to boost container and graph modules
      # Issue ref: https://github.com/boostorg/boost/issues/985
      linker_flags = %W[
        -Wl,-dead_strip_dylibs
        -Wl,-rpath,#{rpath(source: prefix/Language::Python.site_packages(python3)/"mgis")}
      ]
      args << "-DCMAKE_MODULE_LINKER_FLAGS=#{linker_flags.join(" ")}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import mgis.behaviour"
    system python3, "-c", "import mgis.model"
  end
end
