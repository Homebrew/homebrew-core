class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  license "GPL-2.0-or-later"
  revision 2
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  stable do
    url "https://gmsh.info/src/gmsh-4.13.1-source.tgz"
    sha256 "77972145f431726026d50596a6a44fb3c1c95c21255218d66955806b86edbe8d"

    # Backport fix for newer fltk
    patch do
      url "https://gitlab.onelab.info/gmsh/gmsh/-/commit/3b3f0f7e16430939b345889a9e31b50104d5baf3.diff"
      sha256 "194b2822123c36e18260db5c14b98127c2a6721de2f5272bd0bd9456580465c3"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2506b4186d578e85cee9f735761092a6a55b43b8e087eb9ae1f1ee13b9021b30"
    sha256 cellar: :any,                 arm64_sonoma:  "93926045fcf6658df158a978059212fd6f8534fb8e43a7df463ec400e79a0a49"
    sha256 cellar: :any,                 arm64_ventura: "e8e4a83a8911856db8de762a2f2bb6359ceed490b9247b410b0e08e83e606e20"
    sha256 cellar: :any,                 sonoma:        "03e3419ff74a9e9dc82e4c54b8ebb71c6a78fb6cd789b4a4362b4d64222d017c"
    sha256 cellar: :any,                 ventura:       "2f1552b5b8899c764c3547d382b32afd1b6fd9c845aede3d5ca2d57423d78257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503f8bc1c74210e0303be0b398a322345fcf444b65fc22ef2c993e4c00cf582e"
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
