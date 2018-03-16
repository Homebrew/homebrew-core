class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-3.0.6-source.tgz"
  sha256 "9700bcc440d7a6b16a49cbfcdcdc31db33efe60e1f5113774316b6fa4186987b"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "57cdad859b421b6cc48f6cf164570f67a1101c03c9b276ec18dce3b5c250e995" => :high_sierra
    sha256 "85e7c6527a94fa3b02d14cce788dc32f6a0b545fa17124f5e4c19288890d8fc6" => :sierra
    sha256 "d9d6657a71acd75de3833f50d46b454c757f6186f1fe44fdf090ac1604c84f70" => :el_capitan
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
