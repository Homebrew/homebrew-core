class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.3.0/gammaray-3.3.0.tar.gz"
  sha256 "03fda338025d31b6a2794550f090d538996bbb6f4888eab3acb39db5a17127a8"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc6dc89f74f66a223ab38551bd8f1bc8697826003367819cc723b52f99568ca"
    sha256 cellar: :any,                 arm64_sequoia: "0a0b50e170779ff89fdb223f9685be9325b1a008eec6344741c6d1e1fe6e21d8"
    sha256 cellar: :any,                 arm64_sonoma:  "5a0242bab26d1ab9577b71eb214634aa795422aaef7a2b30460e5fdbd7e54293"
    sha256 cellar: :any,                 sonoma:        "d8d92e87bc1d89bea2fe753749d3c6469c16572d295ca14427a6f8554a671224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5296aaef4e0cbd3a963a159ff3767c7cba427f4810e8d3c53588e1db4720c6eb"
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
