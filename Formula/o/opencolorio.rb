class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "124e2bfa8a9071959d6ddbb64ffbf78d3f6fe3c923ae23e96a6bbadde1af55b6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "738ce461e519c5fd7152f30062ac4a442804fbdd63ae512bbcd46611c65ec1b0"
    sha256 cellar: :any,                 arm64_sequoia: "a3127f5babe50de226870be9f2131866579a3d8eec456f8ae09dde36923320c4"
    sha256 cellar: :any,                 arm64_sonoma:  "48eb52eccef42fbfd2989e4d0594daaf8e92d8c3f26fd04fc9274cb2c65ff46b"
    sha256 cellar: :any,                 sonoma:        "3880e7c3cd868f639b7e4e301bcffeea401d1759f37cb6668dcd051580520798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260e50ee7fec0ac4e8202e6218d6bbc78d3b3e7e07ae5c14feb0615a687f34eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9c555f35b202205d39bbcb983aeb1eafba765b0bd8a709df860b23a3fe6a08"
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
