class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "1155178da7271c404947d1ff64b6e5028a82575fd532baa26bd6418de5ef2623"
  license "LGPL-3.0-or-later"
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82d38eca576ca0bb74bd0c6a2daecbc51582f903b547aa4a5bdf0940a0781007"
    sha256 cellar: :any,                 arm64_sequoia: "e150a1a4d619eadbf151f88baec82edd919cc37f19b48f5748194b8ea0df895d"
    sha256 cellar: :any,                 arm64_sonoma:  "a557ca251fe57719034982cd1b96f56e3677d499b30634686c6a48d8f1cdfb9a"
    sha256 cellar: :any,                 sonoma:        "1806045e4fbf5f3a7f2554bde2392c94cc27042bec3178328eceec4782b2a6a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41b2728e46aae9e174279f0cd6b7a4a321c421a7cdc3d395ff300e2f1b115aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0cc6b6b1cf975427acfe54ce5a7d8a7ec0af870752b970d4b31d831daedca26"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"precice-version", "version"
    system bin/"precice-config-doc", "md"
    system bin/"precice-config-validate", pkgshare/"examples/solverdummies/precice-config.xml"
  end
end
