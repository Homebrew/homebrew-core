class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b88ef14c0527886d0b9b7f6e8862b8fcb5afd0e1a28b42feec0bd585dc4f8d01"
    sha256 cellar: :any,                 arm64_sonoma:   "7a4ec7d32579b6a7f9febfc03b36d85647af76998c400153e34e101f98a22c7d"
    sha256 cellar: :any,                 arm64_ventura:  "1091061709489217ae3bb88a361d6b2e70141d120a7dcf82ccd5eb82c63449df"
    sha256 cellar: :any,                 arm64_monterey: "1fbf1d2e7d89dd9933bac8216ab6550387d1550c30d0f8784a5d325250c8658c"
    sha256 cellar: :any,                 sonoma:         "3f49ed160e7deae494a3c3c73909c858ce92770ca8d9ecb78cd2f733bc108aec"
    sha256 cellar: :any,                 ventura:        "9731a5df77144471ef6b063136fcc54707659344ccfba96f04431b71663cb7f2"
    sha256 cellar: :any,                 monterey:       "388c8b1b5fc8a8ba4772b273041bae462c65f7120a35afab82dcfd57ac7ca362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d70572e182ec74f00d572fa4ee7fae921c1f9df6bb15d369e25996c8f075ab"
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
