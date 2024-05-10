class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aca637d9472af5c1177f789c012193f2dab84a24631f5d7c5fb92296404e6c54"
    sha256 cellar: :any,                 arm64_ventura:  "4ea6cc2ab4bd6ad7a5950a819a0eeda64d6812facd879ea4772ca63761fcfc86"
    sha256 cellar: :any,                 arm64_monterey: "4994960373664eb3ab2f349659c9de1269072656064d628e3169a8c2a8f1c7cc"
    sha256 cellar: :any,                 sonoma:         "547540b3c66d8a6c48e97e698dd840969a463843923d5cd6923668d0b3efe145"
    sha256 cellar: :any,                 ventura:        "78e6bd8522c39c8826024bb759395b4882c185ecc2ba6ea25a0cb9c2faf3d112"
    sha256 cellar: :any,                 monterey:       "09da893792a6821040a2c07523e4033b83ba78cefe2c8cab2b4dff8a9ff6fabe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec9765e83ea140906be373c1c8e81a905413615831a6a4104a67818b9a246c9"
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
