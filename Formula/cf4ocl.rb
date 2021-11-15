class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://fakenmc.github.io/cf4ocl/"
  url "https://github.com/fakenmc/cf4ocl/archive/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"
  license "LGPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "721f4e1699a3909dff50586705fe8d1ed67b1ee67d34b653f84d76ead782e345"
    sha256 cellar: :any, arm64_big_sur:  "082e1894c94269ec1541fd6148a1dfca0f7385e64fb5e24dd0a3ed70563df603"
    sha256 cellar: :any, monterey:       "e2a0fad26922fc1f84a90837426ff2fcdffa20467cb55a6818a5820c88fb355a"
    sha256 cellar: :any, big_sur:        "c9d99d7a996bc2c2e1ed6c94bd3639ec5bd97a09e6834a260cbd0a165832f094"
    sha256 cellar: :any, catalina:       "42086ab65ee844ca3e982c19592ca56fc4d7e0c1417fc749585dc4f24426c1b5"
    sha256 cellar: :any, mojave:         "bac407173815fb9bed500a83fb8c2cac4c599a4b1c35a6a619adbfa746817162"
    sha256 cellar: :any, high_sierra:    "d5903425babf74b3f3af6b4aebf7e0c583bf0729d15799b4a99208141ca80b5a"
    sha256 cellar: :any, sierra:         "dfbd0e6e303f7f8ff286e38b98562cbf9b18ac880070fcfa19240b0b9c8d4a2a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccl_devinfo"
  end
end
