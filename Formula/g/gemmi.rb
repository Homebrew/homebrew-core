class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "9e2a8a51e62c69bf43f62aadf527ca4312860de8a36c12a8747d3e8ae556f0b3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc264245afab6fce73a2db3e1378f9c0e98e2be858253b88b4063466d81eeace"
    sha256 cellar: :any,                 arm64_sequoia: "b8d9d0dd70cb7374e621ab9aa1cc044488ca8c509141ecf6efcafd86bb7c2acc"
    sha256 cellar: :any,                 arm64_sonoma:  "2bdf40108f7d6d537fd8349c1cbe7b0036bd17c03ec37e6d19a36fe47576a511"
    sha256 cellar: :any,                 sonoma:        "6ae5ee326e72a0301a9dc2a97a15a1adffad9a1237e62900e160be0441b676b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0053ca84fe45cc033fe5cb30c7faaf6e5f4aca3c2cd4abca47fa89421de22ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11db7111cbf9f79e4b050d114543fd536d282ca1eb6d4d19fa69cedd1f87944c"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemmi --version")

    system bin/"gemmi", "validate", pkgshare/"tests/misc.cif"
  end
end
