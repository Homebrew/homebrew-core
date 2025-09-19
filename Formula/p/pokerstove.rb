class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9813ded756c83d5f0ec4e42648a3de6ac4f572f8593a17c6e64943e20f4e27da"
    sha256 cellar: :any,                 arm64_sequoia: "f7130808f62e33bc114d8485bdd8448020f06a6c00449f6ef73cfcc6ce6eb6ee"
    sha256 cellar: :any,                 arm64_sonoma:  "85e003ac98afcd71cd83cfb7c406eed5bfb8e27a7fe0e9a38587dbe70a3f2337"
    sha256 cellar: :any,                 arm64_ventura: "c34a21407e69e70f400fb9c2fd7c1834606498ff027dad0a86e8a198c123e48f"
    sha256 cellar: :any,                 sonoma:        "443d4d27cd085b1230a21f809107ddea5ce8675dea0807988bbc5c1c527042de"
    sha256 cellar: :any,                 ventura:       "3e49b9e0aae12e1f39606dced90b7ca9ab29c40fbf9225e83918c03ecbbb99fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cfdc4881d8bd0797ea748e6cc1e02b9cc38d81449d415bfbb5f07d0c863f741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba1969e30c9063708d69009cab0d8e1bf22a443cb6b320fd51e13e0511af29d"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Backport commit to build with CMake 4
  patch do
    url "https://github.com/andrewprock/pokerstove/commit/8ca71960b3ee68bf7cbc419d5aee2065276054bb.patch?full_index=1"
    sha256 "379461a6e3258ebf9803ff4a52020d027a745e1676d7aee865f5dd035c51c6e9"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    prefix.install "build/bin"
  end

  test do
    system bin/"peval_tests"
  end
end
