class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.11.1-source.tgz"
  sha256 "c5fe1b7cbd403888a814929f2fd0f5d69e27600222a18c786db5b76e8005b365"
  license "GPL-2.0-or-later"
  revision 2
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d619db045cf659826a873ee1c64e3ba643297b28b517d09e0171c7bffd4b00dd"
    sha256 cellar: :any,                 arm64_ventura:  "b52ab40cdc7dd587293a4a2a61ac27b3422003ef3cef628977e83e8e714986a7"
    sha256 cellar: :any,                 arm64_monterey: "cebc34ca3c942f8e3d20c20f29a2c05bfe3f21dc4d1ff40d571ed113184b5599"
    sha256 cellar: :any,                 arm64_big_sur:  "45d996cd1b5e511d088e68f14c80815219a9c13e52f4cf6db8aeef09aa18f296"
    sha256 cellar: :any,                 sonoma:         "25cda750f95329f529a684d852b88ae8a5c258e8eea9bbea8f06407a4423bf1c"
    sha256 cellar: :any,                 ventura:        "85b538e6af48d69e9b3b22f4104e31f85aecd21d2ebb9b9c31f49ff27b019678"
    sha256 cellar: :any,                 monterey:       "921ae55327547c4885b992c04ea84b5ecc26a7c6b8066fdf072b4d871aaece22"
    sha256 cellar: :any,                 big_sur:        "2ff8a02f3d415212e67e5ee7d27045ee904bf6d56b8bece974922d5a11673310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a9a895160065b7791653f2a06086acdf74ef6d21995528aa40aa3ae094b7a1"
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
