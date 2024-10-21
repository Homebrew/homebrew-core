class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0ff3966b9214da0941b2b1cbdab3975a00a51fc6f3417fa860f98f5358f2c282"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b08a1c82a6f2f5e5dec10e08a853726fcacef51b4605f95f89e8e8908ed19fe7"
    sha256 cellar: :any,                 arm64_sonoma:  "2f1b55053fd7ef4a22105666ae8c567c2e49ad3b31a3fc3330928c345dd4b13c"
    sha256 cellar: :any,                 arm64_ventura: "c6343b306d31ede970e02b824f818ae5bf612bc7f1ed184cdab99593e232ce7f"
    sha256 cellar: :any,                 sonoma:        "50863919fdd8765261e4ad779c9941ecacbeaada5fe8b982ad97d8e1fe708ec7"
    sha256 cellar: :any,                 ventura:       "bef54ecf3bf6e192640f2bb937eb34e22f9779108737982816bee3d9d8bdfa7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdbae92d7160b40aa3afb2661a97f3be3367526d1fd170750e24036f037d87a"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "python@3.13"
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
