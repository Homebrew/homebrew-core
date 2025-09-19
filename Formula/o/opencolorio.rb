class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "2d8f2c47c40476d6e8cea9d878f6601d04f6d5642b47018eaafa9e9f833f3690"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0080d3661f13bd044dc2112df588f173165784f9626ecec6d4d1e1a613e02e5b"
    sha256 cellar: :any,                 arm64_sequoia: "f85aaf86faa9126b201612bdb25c20f5e3729cbee148c5bdbd69cacf0c0a9ffd"
    sha256 cellar: :any,                 arm64_sonoma:  "fedb4e92e2dc6adcb929a0fb94ec311e8968b3825ff33f4b52749e0291bf4fbb"
    sha256 cellar: :any,                 arm64_ventura: "9c49db2a31a708c60dbfcf978f88b39e48104167bfdc181aec30cb8c023814e5"
    sha256 cellar: :any,                 sonoma:        "e3fc9d48a898aa8baae7c070c78b24ea8701a86ae187f6af9c7d3f0bcd0594f8"
    sha256 cellar: :any,                 ventura:       "ad404a385457f7c56f6761b77227cb42645c7f17d59608ecfedb836eb84f5b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb413430a7b00287f839e8462cf19c92e6f84718ce657ef4de9a20a94fad9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f9234e85862a6a5761e0b1cb4ef2a2653607b9c0321108f7d90a21de94e731"
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
