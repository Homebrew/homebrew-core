class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.1.tar.gz"
  sha256 "f5b556aab130da0c423f395fe4c35d6bf509dd8fc958242f2e37ea788464aea9"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00031d296c66f07c93873ccf0d591543b32cecb2a4a2028badb00de8efe0d290"
    sha256 cellar: :any,                 arm64_monterey: "4cf5e165f080678d90509858aac09f8fb0d7d456d60507e776823d910cb03553"
    sha256 cellar: :any,                 arm64_big_sur:  "dc5ef7e662788b84c4b77641505187e2d7350b0cb860be2de6758556e7d2b1fa"
    sha256 cellar: :any,                 ventura:        "4c882ebc70ee1a5a936224cdb6dd87498f0a679807465084bcefe8975fdf2816"
    sha256 cellar: :any,                 monterey:       "a7bc885365b452c7ecb6fb15d8d5c6cc4cc0b56cfbe0bf590051415a9e9bcd00"
    sha256 cellar: :any,                 big_sur:        "ddd5890d15d2e91048dd43a96690cb5a7c3e80432e0e1af4b9ad8ef5bd126f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a981f8819c30768bc39ca6cc37014147402bdeba1840cb125c1753a85c9f33ac"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.11"

  def python3
    which("python3.11")
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
