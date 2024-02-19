class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "64a75f730a1aae1b5e41d543e4e295489ccc2cbef633268cb8821f74c6cd6800"
    sha256 cellar: :any,                 arm64_ventura:  "4388bac6e2aad2d458afc347f80b67974d440def978d8b456a8e7c1cd383a29c"
    sha256 cellar: :any,                 arm64_monterey: "de4b660e6ac230ab2f1fb1fa143f04ae2e7f76d14a186e589190cffdd70821f3"
    sha256 cellar: :any,                 sonoma:         "7d80774d774db577c4f75e8aa4276775354a211af0d289e82ab7037a3a275d3d"
    sha256 cellar: :any,                 ventura:        "600cc77c4148d999f0ce6f5b1d8d890916ce44c0b7625fa08526598cd85e2a34"
    sha256 cellar: :any,                 monterey:       "461a960a3563f8ef7bfcd8b5f95baacda71a9430fc70f01b3ecda861796df92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "036395c5a067f0bedb07155ba3c575ec3167155cd94e81e0142ab5ed8340c187"
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
