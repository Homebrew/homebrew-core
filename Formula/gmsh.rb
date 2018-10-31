class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.0.4-source.tgz"
  sha256 "0a4269a133b6c23a3fca5d3b381d73117ea073b3fbb2c867327677df87a679c3"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "f32487ea4bb0bb69c5a919114a8a47fb4553c067b0c13b8c7c3fea02349740e8" => :mojave
    sha256 "ee0290632bf696cb34e1a554f7c2f749a1b89b18bde9a219e95e80b944fe24f9" => :high_sierra
    sha256 "404d8578f91b65a4fc305c0eacb24a5673e6b576ebb071b1186f2c1e86c3db21" => :sierra
    sha256 "901558025b6a05e1982f7d93330089a3432445e5ae3d97d9815d7917f677ddf8" => :el_capitan
  end

  option "with-opencascade", "Build with opencascade support"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "fltk" => :optional
  depends_on "cairo" if build.with? "fltk"
  depends_on "opencascade" => :optional

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
    ]

    if build.with? "opencascade"
      ENV["CASROOT"] = Formula["opencascade"].opt_prefix
      args << "-DENABLE_OCC=ON"
    else
      args << "-DENABLE_OCC=OFF"
    end

    args << "-DENABLE_FLTK=OFF" if build.without? "fltk"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # Move onelab.py into libexec instead of bin
      mkdir_p libexec
      mv bin/"onelab.py", libexec
    end
  end

  def caveats
    "To use onelab.py set your PYTHONDIR to #{libexec}"
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
