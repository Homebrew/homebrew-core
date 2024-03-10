class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.1.tar.gz"
  sha256 "64e7f5d3ce680262b865c7aec1381ffb13d13f75dd985b964ce33806e1bbf386"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d9fe2fe27a89de5b5fadcdccd7e7446636c50fef43eedf00ccb144c51bd5ed0"
    sha256 cellar: :any,                 arm64_ventura:  "e5e29f8389457fd94c5a01a3b68a00c51cb6f7620b23ae2a0706bb88293f17ab"
    sha256 cellar: :any,                 arm64_monterey: "f3bc95620fce53821276b736d3b44fa6398e387abbce78c8fe9036cec7280bae"
    sha256 cellar: :any,                 sonoma:         "d9b32e4a4e2f8e7741ae4aa446532bf8e2109253896291aad4f13f71eadc2ac1"
    sha256 cellar: :any,                 ventura:        "04880d4fc273713eb4421beab4b29e3ebb0d3b33f37b0215c293b29036fb580f"
    sha256 cellar: :any,                 monterey:       "ba68aad11914a674cad2c130885703933e423ea3f3db6d486a95da316f149fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93f69c0d7d514b5dd3802457c923bbc20c5f0c97e871e1245aae16ae0f55cfe"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
