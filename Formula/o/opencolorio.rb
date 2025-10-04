class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "124e2bfa8a9071959d6ddbb64ffbf78d3f6fe3c923ae23e96a6bbadde1af55b6"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bc3db962e7e25e36d4abb16918a9501ef5716f2ad98d660b6fb37ca60368203"
    sha256 cellar: :any,                 arm64_sequoia: "5245f2fddc131ba247768a3b5b60bf7bf13e0f9b6b74fa6eabd2f84446e54950"
    sha256 cellar: :any,                 arm64_sonoma:  "ed0ff9d02dfc2c5eecf684a84deda3c7afbbb69283ff887a7f4d8166d8671a9d"
    sha256 cellar: :any,                 sonoma:        "4e40ec32c90362291b2a70f99bcad4e89b8fc2b01de96a7e29733dfb8bc78e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae718e50f8ac3c52f94aad223c7acba70a058f656ef6357d54828082a9df88f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfaddc5940f942ebe23f415e86a58f89b35b72fcc52ff83d583c33f3ebd7fec5"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.13" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
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
