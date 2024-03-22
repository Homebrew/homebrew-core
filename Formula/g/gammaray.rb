class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.0.0/gammaray-3.0.0.tar.gz"
  sha256 "acd27dbbcbdf73fed497e0b5d6c477f2e11b59c48499752602677037dcd64ba5"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed27b8c86aec17f17c7875f62d4c458bc7aea3815efad3f41c52c2085ae58779"
    sha256 cellar: :any,                 arm64_ventura:  "cdfa6f0b7d9259d1521dbc72848acc0cf6c4d849cf0e4839abf8c5917d1b0d0c"
    sha256 cellar: :any,                 arm64_monterey: "bd87853b2ed17be73eeb30d1c92dfdeb440b10a2bc07abcc218e8aaab124b7f7"
    sha256 cellar: :any,                 arm64_big_sur:  "4e9ef40af8d3d6cd265d229493fbd29c1d63b620e2f84cc5feaa433db00f07d0"
    sha256 cellar: :any,                 sonoma:         "c9894975917ec85b75743dc2fb2b145125047065b10568f3cdc350c70d89a572"
    sha256 cellar: :any,                 ventura:        "493a498c3c596ed32bc22e09098ff16e1480ac7b0070718ca3b6a104b41589f6"
    sha256 cellar: :any,                 monterey:       "6c29e287992d0fc20bca5c82ec8ea1b549d80b84684cf3232c98949736e5e52e"
    sha256 cellar: :any,                 big_sur:        "cd970b55b98e116fbbe42db084a04909944c4b909ef332a7ba1837b69e09b1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df768d78cb513480ebf945214f26c7a350875990fe146c8e92531fc924674389"
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  fails_with gcc: "5"

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
