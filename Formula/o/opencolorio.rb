class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "08cb6213ea4edee550ab050509d38204004bee6742c658166b1cf825d0a9381b"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e69e12dc26b361573d614b2a83f38e091d3657bad1ac5b53037de07c316d77a"
    sha256 cellar: :any,                 arm64_sequoia: "2e38c440463b246b9be3ebc46d0cd27a8ec8fd0f491f1d8eeb809bd2094bc842"
    sha256 cellar: :any,                 arm64_sonoma:  "0fd7e060adb97cdccf45a563ae8315c1f0405da7c9659b737e8cadfc6a3f36aa"
    sha256 cellar: :any,                 sonoma:        "103b47a4b03ec353922f847f56515b71a8c51e43a8c41cd46e2a0ff27c5d5eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad1aa95322f6aa2afce1d2fc7e19fc6b15c3f8a2ecbba27e6948a2eeba4d5b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a30b9ad1b9eeac37eefa73e6260cb9408957f4e232c8d9e66544eced468ca591"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "expat"
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "yaml-cpp"
  depends_on "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  def python3
    "python3.14"
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
