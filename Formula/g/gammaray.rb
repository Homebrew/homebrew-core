class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.1.0/gammaray-3.1.0.tar.gz"
  sha256 "93b52d5318374896621e1d8b5dd03379c53e0458b1633b539d18737fe8c300cf"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "856f4fb5562c31f46b3598983b1badffd86d980a816487c5968099ca72021979"
    sha256 cellar: :any,                 arm64_ventura: "898f7d5f8a2558023706268424da3c6c39ccdde70fbbea6d6901eaf6ba8ee800"
    sha256 cellar: :any,                 sonoma:        "ea93bdf906fa8fb37f5f4aae52beef3915de98237951a633a97e2845d26d414a"
    sha256 cellar: :any,                 ventura:       "68ffd905f8553fa2e2ec6cc6a156a187d3470448c37f6be4ebc4524003a75caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398b131220442b19baaacd325476260fe62b2cc6b8e250650e7343e820fb24ba"
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  on_linux do
    depends_on "elfutils"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    gammaray = OS.mac? ? prefix/"GammaRay.app/Contents/MacOS/gammaray" : bin/"gammaray"
    assert_predicate gammaray, :executable?
  end
end
