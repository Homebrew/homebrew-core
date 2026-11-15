class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.1.tar.gz"
  sha256 "61afae1a367dbb150b24ca85f042efb15a77184a54a746f11c08d9b7cb9e94f3"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "93d3ad11a8a7be016d96188709fb77aae71e09945fddae2cd922115340c32b2f"
    sha256 cellar: :any, arm64_tahoe:       "65d74f15dc392729d425774c8af8a30aaa280cc8ec6551eef21420f8c5cf95a1"
    sha256 cellar: :any, arm64_sequoia:     "0e87d8c6178fa5ee20cdf9da93d7fccea5fb2fe808dd9bae82ba2a40a30c21cd"
    sha256 cellar: :any, arm64_linux:       "1c868d1e538b72f95071c4709a79a5013cd52d4beea84b6db772bce16a3b290c"
    sha256 cellar: :any, x86_64_linux:      "b44db19b511f7af1ffda2216cbc932320ec52997b78939218ea947d77c13184e"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build

  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "tbb"

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
