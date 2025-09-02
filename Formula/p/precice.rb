class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "93523f1a56e0cfd338d8e190baa06129ee811acdb1c697468a3c85c516d63464"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.13"

  uses_from_macos "libxml2"

  # These patches are upstream but unreleased
  patch do
    url "https://github.com/precice/precice/commit/112f0289028c32ed4ae86b57be9a58a151d088a7.patch?full_index=1"
  end

  patch do
    url "https://github.com/precice/precice/commit/625092d2c2f23f021708e8d74228d523742d1e1f.patch?full_index=1"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Migrate to precice-version and precice-config-validate in v3.3.0
    system bin/"precice-tools", "version"
    system bin/"precice-tools", "check", "share/precice/examples/solverdummies/precice-config.xml"
  end
end
