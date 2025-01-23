class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "d4eb15408b33dffd6ba0bba9a53328085b40bdd9319fa3d0d7348d06a8cbe842"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09ace865c0e44550c5642cb0710fc72bcfa40e7b22f38aafe07458d6dbc794d0"
    sha256 cellar: :any,                 arm64_sonoma:  "87b0c29f5595d393a76ac33db2efd96a99e1bb531a792a57708f9dbaaef97994"
    sha256 cellar: :any,                 arm64_ventura: "e6bfaa96d7d4bacffc8cabb48e9ce40eb1a7c973e67f22beac0da0b138d94f6c"
    sha256 cellar: :any,                 sonoma:        "9b5789f446304b85ad4ff79fe73b353a1acfa6d564d021c86a5f766b97039a88"
    sha256 cellar: :any,                 ventura:       "fe6b6df8642a3a1a8c5c6690042fbf44ae59559d3a27d56bb1c44b8b3cf4da1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5294782fb736ba42baedbd1d9999f5b2611b76c6711f61d9f2867c3e0f3c172"
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
