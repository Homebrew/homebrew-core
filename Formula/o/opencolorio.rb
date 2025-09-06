class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "2d8f2c47c40476d6e8cea9d878f6601d04f6d5642b47018eaafa9e9f833f3690"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff1674c4de43f5ec084a0ba475fdfda2f0ecf00f974fdf3476c1b905706ab4b2"
    sha256 cellar: :any,                 arm64_sonoma:  "223d1990ae687fc674526bbda8cbd0750294aa660412102fb70d382659236ce3"
    sha256 cellar: :any,                 arm64_ventura: "578488f4b4c89cfc786a5185c226234d37d55cb8066411f6446f9d18340166d4"
    sha256 cellar: :any,                 sonoma:        "35dfbc4519b22515f50e4e35936f3589abcc6f6a8cb9eb3f518ca548474ed924"
    sha256 cellar: :any,                 ventura:       "3c98c45371a5dc8032ec1133073ab61f923ee929a3420da57784fed4c9feb067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56504df9809d3ed3d912c4278d928ccece7867ef0e5b69601ebc84546a4ba394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "755b5ccbf7ddf7df2d430c073283e2bef5c581598a518bb9891da04dfbb57133"
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
