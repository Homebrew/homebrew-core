class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.0.tar.gz"
  sha256 "dae915201fd20848b69745dabda1a334eb242d823af600825b8b010ddc597640"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 1
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ee28d46bc4b70f785526d1780062e988488b21f41d2c0b4aaf2589cefde6b6b3"
    sha256 cellar: :any,                 arm64_sonoma:  "eae43945d21d31bf3369db4b8b16d36c01db86d41789057d4eba8f26ef3608d2"
    sha256 cellar: :any,                 arm64_ventura: "cd358ba802ffc4c699b54d11e9bf9535bf65b43207ecfa21918743f84b32a8fc"
    sha256 cellar: :any,                 sonoma:        "336715097aed0e27648fbd2b39cbd26661735d6f65491a8381d5697875a20c52"
    sha256 cellar: :any,                 ventura:       "e7a249000f06e709c64065130eb0c90e5dc6f9517ba487e884b24154aa4c0567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24370fe40f667075ecef3f63499624e198e5e7374c4e5de420bf5529129ddc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f3231a4541ddb649f97540a466da65905da439144bca7718e463d1ee1f1a1f"
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
