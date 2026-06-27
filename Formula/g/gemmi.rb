class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "9e2a8a51e62c69bf43f62aadf527ca4312860de8a36c12a8747d3e8ae556f0b3"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3dc2a4467fa0ed0928090f9cd53ef636ef03dd68902a1922d298e09b992f6c4a"
    sha256 cellar: :any, arm64_sequoia: "2077899d6278a7f1ca8ccb53baafdf1b99eb9b236ac8564ac2c4920043941f55"
    sha256 cellar: :any, arm64_sonoma:  "a2c1dbcb81cbed37589504edb8e0191e12493a2f1f0780b988aba084623c39d4"
    sha256 cellar: :any, sonoma:        "f73c874975cd7286f5cc420129ad7db5996e8aee21fd7b8efb3a336ab04c1dba"
    sha256 cellar: :any, arm64_linux:   "7c00d4a2c478413c35c00072b362568ffe153089e8ba2f60a7ecf69ccf4336ab"
    sha256 cellar: :any, x86_64_linux:  "9ffa4d84b28bb74552a6b0ed7eef9b26cad33b46b403a8cded4a7e927e1e8b64"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
