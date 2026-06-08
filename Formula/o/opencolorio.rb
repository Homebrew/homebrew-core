class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "722601e01b78b7a12da4829cb450674935f404b0e508f3f20046fa77570e3272"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b0813d78b3d682eedd037eed1ffdea77789be0e1d646c10c8867cb1ffe924e3"
    sha256 cellar: :any,                 arm64_sequoia: "07d927af277f3b4d4a2214b903d8e98cd0501e93194d7d66c8f6402177ff43c1"
    sha256 cellar: :any,                 arm64_sonoma:  "144a0ec28a8e5f0f4caa6fbd56c5e62f9efc9105483b8787ce48d1760e1e51af"
    sha256 cellar: :any,                 sonoma:        "1ded26e55687b43f2a79e6c03cefa728cf25c87c2ac54f534b92b70db8df52d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9be8653abb0c4e297138156044a226b55e7a6184a78aa3690e10106902f4108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0a7734028b65c35ccd63aa6b239686444da7c6c49c76f8c9a2532f801f8bdde"
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
