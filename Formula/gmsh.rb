class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.11.0-source.tgz"
  sha256 "3cf2f24455ee09252c99e64d4e6462956e68f0ff1f37baca0b78c809d6cc557a"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63241b9c89c11d539a292b17b169443e66d74c478b3c7263861ea6a7e160ee98"
    sha256 cellar: :any,                 arm64_monterey: "4b7af91984d0485cc745b2475080cd799838ce6878dfd20f650332d72cb57c11"
    sha256 cellar: :any,                 arm64_big_sur:  "4f5b32b8703a77ca66242748b897e570c4c36c20c5c38988bf82b3239137ef2a"
    sha256 cellar: :any,                 ventura:        "9b92e7f01109512e8d50c2796c22221cd202e3932ed935742e80045af19477fc"
    sha256 cellar: :any,                 monterey:       "f9c21ee22ad8c8080f7f5ea16f2ebf26fe41042d5d79dd7bb26062ade24721ff"
    sha256 cellar: :any,                 big_sur:        "dce9a51ec0c4bd1140f4af255a7545ef5b501121d2c8ee7ced1502df5a49defe"
    sha256 cellar: :any,                 catalina:       "20c1a64af58684f8640c1f85bfae73f4ea856640a73e8fbc2f375ba621830cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d3e63fa400e32d0905f718bfd7b45901b0441e6e934e99ab57165b19d7a7a30"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
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
