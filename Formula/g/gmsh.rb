class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.13.1-source.tgz"
  sha256 "77972145f431726026d50596a6a44fb3c1c95c21255218d66955806b86edbe8d"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0abad5c46af36b742b304fb4f3558fd8aec44e005d7f893ca4eb97c73b53a48e"
    sha256 cellar: :any,                 arm64_ventura:  "8e4dfac9f7460fb14002372afc70332eea13a04ae13d50df2452ea07241045ca"
    sha256 cellar: :any,                 arm64_monterey: "f0c92cc4fb40cb0572c6d0a7bb7cdca3f20b2af68c118da92380016ad2eb1121"
    sha256 cellar: :any,                 sonoma:         "c1bc6646c70f12474a5a1f8a366977f5d8b161a402438fbe80dffd2390c54bea"
    sha256 cellar: :any,                 ventura:        "ab9b5def53bd132ae162329c84e257cd2f1207130ec80f2084cae4bc1e47ef11"
    sha256 cellar: :any,                 monterey:       "3a79509860746625e7edb671d0a372812df932b38d4f26d6c2f2e8076af02789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a834fd8e0c9327c45ff093c4a552549764d79a692914aaa7a665cd3ea380752"
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
