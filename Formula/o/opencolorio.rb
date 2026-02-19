class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "08cb6213ea4edee550ab050509d38204004bee6742c658166b1cf825d0a9381b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "006995bd26f4b71e3d39e04353981e4e9b4832ef46fc9999474e8e1dc5d8e427"
    sha256 cellar: :any,                 arm64_sequoia: "da0da49493e904545c2d9cc5b21093ac2b52a5b15ff7ceead7e30f3c8bcfd6b1"
    sha256 cellar: :any,                 arm64_sonoma:  "a961bd718fa4ab9c3d175597f390b56453cbf80681e9fdcd3b8c1a69d39ad443"
    sha256 cellar: :any,                 sonoma:        "92ab8f5361784f731e5271ccc5c536c54c10ab7150a09fa499fa19809d161716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b876fb97492d71189ae6184e2e588d1d8ae4acb7e9ef14aeeaede4d3f9b6f59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4561d65b746de89abd8838962c0e49c5b0095cf2c1cd467876adeaf311672d91"
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
