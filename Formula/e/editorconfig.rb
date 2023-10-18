class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.6.tar.gz"
  sha256 "36052a5371731d915b53d9c7a24a11c4032585ccacb392ec9d58656eef4c0edf"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c71bfb3c64a8a6b68985b889ad84d9625f4ce3e49c17635aab17e4cc57855605"
    sha256 cellar: :any,                 arm64_ventura:  "bbeed6b68bc52b794f58f8b44de2f0d09375a74aa77a56699517e618b4895a20"
    sha256 cellar: :any,                 arm64_monterey: "445a27596e9129b5436ec906a7de8b216359837e162d4a2c452c01d32c0cebee"
    sha256 cellar: :any,                 arm64_big_sur:  "cc1242db975617d3813647af68678d948d154570038f44d8ef231bd41590d0ff"
    sha256 cellar: :any,                 sonoma:         "2a7c3ce9537078f2d323b4ee995bb14892bb0e2b89dfc74f282675c8ce8cb7ba"
    sha256 cellar: :any,                 ventura:        "8ad4ac64856b3b4b3622a9f835c192d34d95aeee846297309dd232537debf43a"
    sha256 cellar: :any,                 monterey:       "53371ea6d475c96c68443062893d0e9ec100549da7f57c62abdf40e43e943e88"
    sha256 cellar: :any,                 big_sur:        "a51958424b3961a68857092a80dce49a04f18b0584b952af68e0bc8e5e7183ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8791e9513abccd5ff2ef61315fa2391966e520526065e5de5832c23ed9d828"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
