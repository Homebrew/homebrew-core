class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.0.tar.gz"
  sha256 "dae915201fd20848b69745dabda1a334eb242d823af600825b8b010ddc597640"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 1
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "609ed0597809fb94917de333e84bc8e4576ca5578fc9cfd597683930c8271319"
    sha256 cellar: :any,                 arm64_sonoma:  "f0840ea4a984ff1e339fe09aa34a15558e7006188307b15240d7c80d6061c9aa"
    sha256 cellar: :any,                 arm64_ventura: "3cff91f04f779e56f1153c0321747fc33d2e836abaff7eaa16fce596872b7392"
    sha256 cellar: :any,                 sonoma:        "5529533762511b3008c9bff15f41e9531901e783f245029b6257e7c17832325d"
    sha256 cellar: :any,                 ventura:       "1732d4ba927e76eedc4ad01d9bc881df0502b5136a76a83854bc188a1770c917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d0346eb3292a2c9b6502edbb0b7af1da1c89dd6f05f4499728095df471bc3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b829e753ccdb888bd8a946a37f4a83d1090bfc033341fb3f9bdf29faad363609"
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
