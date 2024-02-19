class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.12.2-source.tgz"
  sha256 "13e09d9ca8102e5c40171d6ee150c668742b98c3a6ca57f837f7b64e1e2af48f"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70cc0d34083dc16aeb54a3f1cbea1f6942b36fcd6b379e4777b84837efb97fc4"
    sha256 cellar: :any,                 arm64_ventura:  "a3b739779fedd2d1edfd0f548c26eba8a4ef5cb7875ce87f58da41fa2154759b"
    sha256 cellar: :any,                 arm64_monterey: "597b10464f842e817daabbb8393daa70af18ddc70770db94f8cc23c7e8906f93"
    sha256 cellar: :any,                 sonoma:         "74af523d850b6e95e386ead4547f12a9caee3b4ca3527251bbb23942f00547c4"
    sha256 cellar: :any,                 ventura:        "156956650e7491b0dc8671e883ec53c45820c8a3e90ff4f3844b4b81cbd19d68"
    sha256 cellar: :any,                 monterey:       "affdc85dfefc153609b9db15694210d8422889ede1585be1975a13a11fde1ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aba29afad40012487bbbc76200d9fdfc3708a49f2c008f7efa5f4807e92d230"
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
