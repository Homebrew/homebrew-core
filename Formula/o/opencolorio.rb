class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "784ac37bde5b9c6e5dc15f23d1235bd1452d376cdc03627d6d6dd310f375a735"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "1875fc9c938fc6d92a14e6737f2916a22f61ddc4d6c86c138de626ff1e37a3ea"
    sha256 cellar: :any, arm64_tahoe:       "d810e410ab8cc4a5f070e328bf1242a474b7ec1e45c741d7e555fea37a988247"
    sha256 cellar: :any, arm64_sequoia:     "b07a8386e0461ee5ab116478e538b2a4e954a05bad8398e3df63586c5ee0e38a"
    sha256 cellar: :any, arm64_linux:       "9e15fb67bd4414dd06611faced4217391703cec9f0099eb70d9bd04cae3d76da"
    sha256 cellar: :any, x86_64_linux:      "76a59ba4315208961b26efe3d92c15e5643c3c301e06df689b1cfbc6aceab115"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.15" => [:build, :test]
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

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DOCIO_BUILD_GPU_TESTS=OFF
      -DOCIO_BUILD_TESTS=OFF
      -DOCIO_INSTALL_EXT_PACKAGES=NONE
      -DOCIO_PYTHON_VERSION=#{Language::Python.major_minor_version python3}
      -DPython_EXECUTABLE=#{python3}
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
