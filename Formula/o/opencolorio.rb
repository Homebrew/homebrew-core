class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "2d8f2c47c40476d6e8cea9d878f6601d04f6d5642b47018eaafa9e9f833f3690"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd4ce40466893d4cfb51455109afc4b3f69024d6a4fdd008f87cc61658e4fd37"
    sha256 cellar: :any,                 arm64_sonoma:  "da363d024bb2473440be47e1c3cb5720219ab747815fc96e83ccb16558720e22"
    sha256 cellar: :any,                 arm64_ventura: "7df6dc5b16c82aaecc3c6d5366b471f908e479e5583152948d5829b2a9fc024f"
    sha256 cellar: :any,                 sonoma:        "4be7e329a8f5b155d8fa8209d01d2fcb8bb1953bdbd9ffc64282f3fe28eade8f"
    sha256 cellar: :any,                 ventura:       "4c67b15aaaaba4b75bcd3d0dba1193edeb25ab3d9ca77365a35fb11970efe86d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c0f0c49ea791180f3d12d806882b2b60c36b0e27b0022d69223a1b06a2e6b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e366c2cf6a6dab2e5abac729a3b08af8bb16c1711e2c6642e05e23802df2a1f2"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.13" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "yaml-cpp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  def python3
    "python3.13"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DOCIO_BUILD_GPU_TESTS=OFF
      -DOCIO_BUILD_TESTS=OFF
      -DOCIO_INSTALL_EXT_PACKAGES=NONE
      -DOCIO_PYTHON_VERSION=#{Language::Python.major_minor_version python3}
      -DPython_EXECUTABLE=#{which(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
    system python3, "-c", "import PyOpenColorIO as OCIO; print(OCIO.GetCurrentConfig())"
  end
end
