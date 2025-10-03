class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.0.tar.gz"
  sha256 "dae915201fd20848b69745dabda1a334eb242d823af600825b8b010ddc597640"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 2
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e00b040187f23e9f170eefedc928462500f5dab173a4f81bb87bab38ee0af7d4"
    sha256 cellar: :any,                 arm64_sequoia: "eeb9d97eba82219d9aa871c357ad729b38897f62654db238d0b8aacfec4f8af6"
    sha256 cellar: :any,                 arm64_sonoma:  "825e6a2ea310053a15dacc280a00cd1c14aa200985a588375fb37eeedd808096"
    sha256 cellar: :any,                 arm64_ventura: "2c95f087b9a89026c345477fce004a13ad88376804c7222da9310f5637b86aad"
    sha256 cellar: :any,                 sonoma:        "2a270fb617d534331a5d15b27c4ac77edf5921456d3eb5cd6cab5e56a1bbd5e2"
    sha256 cellar: :any,                 ventura:       "adb7eefc819507ef06028d0075d17f2f1919570dd3eac0be42187cf3c3348e39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12bedcbecfb86831e8e5457debb9fc6abd14d75cb562cc48fb1fbf3a1a8508a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d57981d82eb7676b31402f7d3fac080a52f5252adfb838cf026a517f1e247e"
  end

  depends_on "cmake" => :build

  depends_on "boost-python3"
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python@3.13"

  def python3
    which("python3.13")
  end

  def install
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
