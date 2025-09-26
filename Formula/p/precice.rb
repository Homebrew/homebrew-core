class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "pending"
  license "LGPL-3.0-or-later"

  head "https://github.com/precice/precice.git", branch: "develop"

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.13"

  uses_from_macos "libxml2"
  
  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DBUILD_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"precice-version", "version"
    system bin/"precice-config-doc", "md"
    system bin/"precice-config-validate", share/"precice/examples/solverdummies/precice-config.xml"
  end
end
