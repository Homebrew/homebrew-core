class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.5.1-source.tgz"
  sha256 "58c7c9fe44704c0b16ad4a437865d12b5dfb68877514358f6c06735cfeed5c66"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "5c057286c066b45c108153927013697e4cb56513df3e6a42a35fa9e079866b4c" => :catalina
    sha256 "285779bdb1e42f7568c8d1e2512d53b8b92d3d760b45ce289daf07b1ee6a67bd" => :mojave
    sha256 "bf6eda2dcc78abf608b4dbd4155f2be44ba0d3fb57fbadf46f3f3bd53b03d627" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    args = std_cmake_args + %W[
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

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # Move onelab.py into libexec instead of bin
      mkdir_p libexec
      mv bin/"onelab.py", libexec
    end
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
