class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.13.0-source.tgz"
  sha256 "c85f056ee549a433e814a61c385c97952bbfe514b442b999f6149fffb1e54f64"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3161b19af649303c8ff44c23c48e51a877da2d53258eaff5d945a80c485e4703"
    sha256 cellar: :any,                 arm64_ventura:  "ad87047aac581de1c96f827a3f989fd004914d55a5ad404ae0bb4d5cccada6cb"
    sha256 cellar: :any,                 arm64_monterey: "70475e4128780d24dc14e3f8c9ca4f1c3b37a9d551e02d10e8a3dc3a3341858a"
    sha256 cellar: :any,                 sonoma:         "d83b3227fb19c254adfc0f0d7153285e6008810bcf4258ebd88f189b9a2f3c1e"
    sha256 cellar: :any,                 ventura:        "94f93bd1db346b3c339f487ed6693fe019810ed84e49ab11fc78f043d5ca5c30"
    sha256 cellar: :any,                 monterey:       "817a8ca892e8d8fcc525c62c05fe63d22846683b9dc855f43d69bebb51c18ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3418df349ed485c8f4dc5f29680b660dfcf356fd468f3143ba8f010927ff164c"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_OS_SPECIFIC_INSTALL=0",
                    "-DGMSH_BIN=#{bin}",
                    "-DGMSH_LIB=#{lib}",
                    "-DGMSH_DOC=#{pkgshare}/gmsh",
                    "-DGMSH_MAN=#{man}",
                    "-DENABLE_BUILD_LIB=ON",
                    "-DENABLE_BUILD_SHARED=ON",
                    "-DENABLE_NATIVE_FILE_CHOOSER=ON",
                    "-DENABLE_PETSC=OFF",
                    "-DENABLE_SLEPC=OFF",
                    "-DENABLE_OCC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end
