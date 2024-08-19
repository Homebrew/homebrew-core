class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.1.0/gammaray-3.1.0.tar.gz"
  sha256 "93b52d5318374896621e1d8b5dd03379c53e0458b1633b539d18737fe8c300cf"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "27b11ab0fe6bbecfd521f137e55db9dbc981f1f36baed3059fb97b1836056def"
    sha256 cellar: :any,                 arm64_ventura:  "248e616d7cd507ed84bf5f4650b2cb419ba81b00bcace44dde18714b92585ca6"
    sha256 cellar: :any,                 arm64_monterey: "d524a2b8c87cae2a3f15f81761fc9bb2586861314b252b2f83a0420d8c59d789"
    sha256 cellar: :any,                 sonoma:         "e577a7147b5fe61916eea610c6fe288ff8748195c1a20efd9d507fbae2789658"
    sha256 cellar: :any,                 ventura:        "80354ec89605d4ddf345593bb2bcc8b05cde79cbc7ccf972eb5302859e484163"
    sha256 cellar: :any,                 monterey:       "bcf7529613e3f65821f3709780aa2e36621aa62c4833cccda703c49f3f4fb8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ef430a3fe1d565cf9cd3c129fec0477a3562e862058ffd6caf3cb92e44f14a"
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  on_linux do
    depends_on "elfutils"
    depends_on "wayland"
  end

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
