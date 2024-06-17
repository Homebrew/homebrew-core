class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "6bbf4e7fa4ea2f743a238cb22aff44890425771a2f57f62cece1574e46ceec2f"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0db0e5ebd3e423f988a351de2677cde0a027ab10212dd6535263e16900530f69"
    sha256 cellar: :any,                 arm64_ventura:  "0a35033f31e6aa593f141238895b3fe383527f662592e106a76e175d919d0815"
    sha256 cellar: :any,                 arm64_monterey: "68193cb0f8b28037f26bfcf1ade5e1ffcc757da8dd9d4782a47307e2f5183e5f"
    sha256 cellar: :any,                 sonoma:         "583e1b16d1981250865d052511160b254ce71485b82107da6896e4642c254d76"
    sha256 cellar: :any,                 ventura:        "1841a51311fce945dff91344b05fad32c1ca2e2e96a094ebc6b60b5cc74d0d2a"
    sha256 cellar: :any,                 monterey:       "3f97660a1b3dff405779ed4480475da7c5389c345f35c4d5837f08fe53c4a725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd944816b1ccf312cd3471d87f0cee4fe2d85712a661d1bf13fa10be77d6a3b8"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "python@3.12"
  depends_on "yaml-cpp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def python3
    "python3.12"
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
