class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.2.2/gammaray-3.2.2.tar.gz"
  sha256 "18830a83ca8ba8e6e07d78a88d933c2666eda4b26d3cbdc97e06914f5e92388c"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "188e05f535d2dcb85a2530a3c7743eab2c6b1afd3fbb2ff2f958b62ee81c3ea8"
    sha256 cellar: :any,                 arm64_ventura: "67bef150eeaa9f64e616cdfc242958016ba65b45981a939a63721206cd56157e"
    sha256 cellar: :any,                 sonoma:        "5d49a25721d07658ed17e45396b5edd694f4f8d9f93219938dcdc0904c1f093a"
    sha256 cellar: :any,                 ventura:       "92727212855dd82a000851db16e91f824971aa3185ef4653475037c1462f11bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce7a248ef5b4009c51846317295552e6e2c105ec9d12b28f6294c9133ee9024"
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
