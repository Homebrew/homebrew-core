class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.13.1-source.tgz"
  sha256 "77972145f431726026d50596a6a44fb3c1c95c21255218d66955806b86edbe8d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ed45482acf3bcbc86d9126c68718128f0ea1525f3fc546ab879f2926192791fb"
    sha256 cellar: :any,                 arm64_sonoma:   "9f3836c4ba6bc88d80f5b4b16bb75dfb424abc9cb6ad157eb66de1c0ead79f38"
    sha256 cellar: :any,                 arm64_ventura:  "b2eca4d0f50393fd431f2f4e35f6ef32b17b07f7edcca72f53ae526a2c639357"
    sha256 cellar: :any,                 arm64_monterey: "7c11588d5e558f65d930ce46f2c9587e9a846e5a7471cd8e86a7c1e7be6ebb60"
    sha256 cellar: :any,                 sonoma:         "3de1102defd21daeb01d71f767e3f4d527ff4c6e64eea1af91d4df0125adae58"
    sha256 cellar: :any,                 ventura:        "4e254c102c8b53c09f26affbead6ebd48ea19037c0ac694df0179988498f49c0"
    sha256 cellar: :any,                 monterey:       "19f99aa08e30266ee8d24c60d5c63d6627cce0885084e10a782ea6a93900c08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8605e75e4d5f0f44cc7408191ffdeaa21e9af2c93586f0436b87cb1957823c4d"
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
