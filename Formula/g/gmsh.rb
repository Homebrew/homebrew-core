class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.12.0-source.tgz"
  sha256 "2a6007872ba85abd9901914826f6986a2437ab7104f564ccefa1b7a3de742c17"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d9ba3d7fd8ab4965aa17f5e7b0579d35424cd9357188f6584db82ebabca9fc9"
    sha256 cellar: :any,                 arm64_ventura:  "3c33de717c49045808b6d9644a6c37a8dc24cd8afbd404af861425a42be5f8c9"
    sha256 cellar: :any,                 arm64_monterey: "599a2f9448d5bd3936ca7de0544e3f645a6cda1f5fcf5d4af74e12a57f05f9bc"
    sha256 cellar: :any,                 sonoma:         "1262cb7911ddf6eca0d9a40796b44a1c1c1eb6bc46d2fdaadc97fba0d92ca595"
    sha256 cellar: :any,                 ventura:        "864fb752184e9fb597fa39f324dfd7c86fc37267540f64a5aa575c57ce96d878"
    sha256 cellar: :any,                 monterey:       "c3bbca63f647bc03f6ef4c632fe4b04374c9f5956a404bf395c10ea5457e9040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d31c75fb3ab766cbba918255b51013ca043e3e59d2f656d38bb495b9bae3fc00"
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
