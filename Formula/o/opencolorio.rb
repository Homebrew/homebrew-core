class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0ff3966b9214da0941b2b1cbdab3975a00a51fc6f3417fa860f98f5358f2c282"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "390ca8939046584908885edbe83e8b2ed305554bf171a36249b259d5dacd1b55"
    sha256 cellar: :any,                 arm64_sonoma:  "90a1c59eb48ffa735a566c81a8fddfab4b7c66fe2abc8f77f2c49aa0c0c1997e"
    sha256 cellar: :any,                 arm64_ventura: "f9ffd1513ea17add5e7c2fd686df92ce5c88e38f4c115ca7a5d2c9cc25be630c"
    sha256 cellar: :any,                 sonoma:        "16be5891921c2d0ecd16d31703767e1e7ddc7b0948ab602aff3854863537fc7d"
    sha256 cellar: :any,                 ventura:       "f58a5e868e1aae2cf19c9258353cc8cc0519d609075db2256ba8990de50f4cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b26d359f64be7f20b765ea57f872b99f3b009d188ad9bb95aded39063f554dc8"
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

  on_arm do
    depends_on "sse2neon" => :build
  end

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
