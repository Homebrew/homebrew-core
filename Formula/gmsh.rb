class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.5.5-source.tgz"
  sha256 "899d3cded664124fa387da57b6f170f47a7e712c7744aa3562779897e2b9e251"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "b48f8c67642ae8cedd57af5b78049289a5198454cd697df5e6973f481195306b" => :catalina
    sha256 "a91bb993bc060301477be0fe35cb1f28680f9a110efb866df80f83ac1522637b" => :mojave
    sha256 "ff3ed207707dcd6a251bbfcbf325114b3c9daa93ad9495ae21a227f7dbe3ce27" => :high_sierra
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
