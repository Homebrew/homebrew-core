class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.13.1-source.tgz"
  sha256 "77972145f431726026d50596a6a44fb3c1c95c21255218d66955806b86edbe8d"
  license "GPL-2.0-or-later"
  revision 2
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2b3a910ebf7ddb5948db46013d847c482ad842f96c103665e368ef7ca03bea0"
    sha256 cellar: :any,                 arm64_sonoma:  "f25a49e4ba3a83ebe8b21a0595ffd0c10e5e9077dd256f444e79d066c81492f7"
    sha256 cellar: :any,                 arm64_ventura: "9270008c00e67bc44583f84feb6b40133fe6b6f4cf36b95e7d4fcd5ce6167f83"
    sha256 cellar: :any,                 sonoma:        "0d95a962363acf44d44d045a979328f03a24567b6a93972af548ac30fa6146ce"
    sha256 cellar: :any,                 ventura:       "11187186b7392a891ac2de97eb738fbe3bd81b77ec1578f21b9e4f32e0f93399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c0e612189189fb9eceac40411dc5be1afb42ba66bc9ec1677bb497bfd3565f"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "open-mpi"
  depends_on "opencascade"

  uses_from_macos "zlib"

  on_macos do
    depends_on "freetype"
  end

  on_linux do
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    args = %W[
      -DENABLE_OS_SPECIFIC_INSTALL=0
      -DGMSH_BIN=#{bin}
      -DGMSH_LIB=#{lib}
      -DGMSH_DOC=#{pkgshare}/gmsh
      -DGMSH_MAN=#{man}
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_NATIVE_FILE_CHOOSER=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
      -DENABLE_OCC=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system bin/"gmsh", share/"doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end
