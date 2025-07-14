class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.2.0/gammaray-3.2.0.tar.gz"
  sha256 "a7c00a5a33c400579002bbe535a667efdea1e726950ecddbf39cf3d8a3f50f07"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "bc38ac14b372b5eadd5f40332cf95989a8d6f2eba6b3b83b8b8f887f16b5dfa5"
    sha256 cellar: :any,                 arm64_ventura: "c3a6fa5468b3d3f020b0ab240fb0da8adbbb90eb9e6b0a6bf3c391bd10d34bda"
    sha256 cellar: :any,                 sonoma:        "7e720fc4ba25f790c4bfa0cff9c2e8e7c03fcf36d6b3c7778e4e674994ceca09"
    sha256 cellar: :any,                 ventura:       "96b2c34f2830bb9183f6851c75098eee323ed6af313e51638b6c0fb034316037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb5af0d09737fa7ffec4563723a98a0911526c75613406c91a70c3f4c5e76ea"
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
