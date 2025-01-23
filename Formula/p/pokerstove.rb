class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "978e66f99c443c8d099a702d1c0dea99055183d8b16f81a3ca793538bef81828"
    sha256 cellar: :any,                 arm64_sonoma:  "81056f1a1c63ba420727ecb48c33ba4c3abe557d34c2bf16a1dddfb313652f21"
    sha256 cellar: :any,                 arm64_ventura: "f723555f1f3a9b6c7a8ba94be52754ec95e732ebf18c86cc0b865c4ea34afb95"
    sha256 cellar: :any,                 sonoma:        "f20fedc6d4c6c45e1dd0634dbe8771cb44c9d577208ca56431b59361a23ce755"
    sha256 cellar: :any,                 ventura:       "624e5ba8a982e3e13f5cf9bb39c353bdc58000f88fbe1f76145b4b1d571942ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45cb8d428fdf24f5dafef8135406ea83c214b0cb73602cf1424d8bccb4c2699f"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    prefix.install "build/bin"
  end

  test do
    system bin/"peval_tests"
  end
end
