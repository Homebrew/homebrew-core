class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-1-1.tar.gz"
  version "3.1.1"
  sha256 "c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "9f5f17dab6ecc4ef0a26c15d34fa3a07e15690459ac36372b0cb9e6a7a9d3173"
    sha256                               arm64_monterey: "b8c4d0d18ffe49772d39f86e9a204262c3e32fef92aa29b38b76d36b61e0cade"
    sha256                               arm64_big_sur:  "89817f17e6d1b7fa33a3a7c9321c2fe529f546fa6cbf59c014de0cf2ca279736"
    sha256                               ventura:        "c8baf6ace5ea1d8700dc74642ebaf1f6a33fe172fcc8e016490688c4c4c66908"
    sha256                               monterey:       "d7a93ad5a24deefcbd87ebcc094a9fe41024e938f54428f2d148da057e3dd7c3"
    sha256                               big_sur:        "f4e76d3d62eabd132f5d177c62bd0c6ecc65bdb89b37d06661f66903d1726eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b1935653e40d9044045217cfeb9476cfb529763887a063ee6b81db8b3b9b3b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.11"

  uses_from_macos "libxml2"

  def python3
    "python3.11"
  end

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
