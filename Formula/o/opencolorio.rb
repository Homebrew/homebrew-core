class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "08cb6213ea4edee550ab050509d38204004bee6742c658166b1cf825d0a9381b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "0ca624f3788e11cefd2b246e8154b85a819c2a40ed83e618abdb93c00dbedc16"
    sha256 cellar: :any,                 arm64_sequoia: "a253b7d210772a5f07acdae83b8707e2c27da64f5dd883f5428e6b5e72afd456"
    sha256 cellar: :any,                 arm64_sonoma:  "24f7868c7417b93233c10265dc9f594e07331d9a00c515a63d27c3baffb339ab"
    sha256 cellar: :any,                 sonoma:        "c1b9c2d7eda1ec4613cd573a4c16414f286155f91f25715f7e0c204053e85fa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9169481ded19f10e1b7c82e7c694d34c30dd78e0ab44107149b303208d869fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d91f280ab35dd2bfb6c30bf2480f9370fb33fd44aec3b542d2fd28ccd4680f2"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "yaml-cpp"
  depends_on "zlib-ng-compat"

  uses_from_macos "expat", since: :sequoia # expat 2.6.0+ (Apple expat-37)

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
