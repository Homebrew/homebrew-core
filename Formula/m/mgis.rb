class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.0.tar.gz"
  sha256 "dae915201fd20848b69745dabda1a334eb242d823af600825b8b010ddc597640"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  revision 3
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9de255b0e7dd13ccacf98b07e48ccc8c47f241eb8c52dc45a650e352b39d3b4"
    sha256 cellar: :any,                 arm64_sequoia: "8777e0f76749fbaf403a6f58f347228504437d570a73b954ea88db500ecc72d1"
    sha256 cellar: :any,                 arm64_sonoma:  "01f29c48e1951f74a20584362183e48ea0a73717d20d73e63666a9166f852ea6"
    sha256 cellar: :any,                 sonoma:        "ca86411b44375bc98f40281b50eda51f914b61bbf137b0c31f0015c85da73e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78cc8af7564994ea4b4380dd99c6598505b6f22a528689bb36d63f126b71d069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f3936f304385534e0ab9d2a7dd5b98d10c7cd4e78c6fda2ad02d3a035b9c1b"
  end

  depends_on "cmake" => :build

  depends_on "boost-python3"
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python@3.14"

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
