class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  url "https://github.com/openbabel/openbabel/archive/refs/tags/openbabel-3-1-1.tar.gz"
  version "3.1.1"
  sha256 "c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "f419ccc5548f2ef7476cf80f63a9202026a342955ab6636b52defa8ff4a49613"
    sha256 arm64_ventura:  "3897a0b1768ca3e0037070cb17890ca83ad9e5ac165832c97b5b3b25c4077164"
    sha256 arm64_monterey: "145b1a3f4d2d295f35bcec9e8698191caccc1798d478fc76563d7eb5301dd504"
    sha256 sonoma:         "cbf0992d5a6f648fc362d7c0e6a34ff4f36c4997d6220e8d0c6d2b784e5b4b14"
    sha256 ventura:        "ec8cb56581eaaf3cc1f39b31697ddf23898a9da5716aa6905aeeaca99a30caa1"
    sha256 monterey:       "dfee32016d8264bdddbceaf883e7997f12e5064ad7596b0dd898b0fd0e76a52d"
    sha256 x86_64_linux:   "7e950edb7779a9f98d7acee8aab9215fd3fa9fc64ab57b64fe2a2f37940d72bc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.12"

  uses_from_macos "libxml2"

  def python3
    "python3.12"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DRUN_SWIG=ON",
                    "-DPYTHON_BINDINGS=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"obabel", "-:'C1=CC=CC=C1Br'", "-omol"
    system python3, "-c", "from openbabel import openbabel"
  end
end
