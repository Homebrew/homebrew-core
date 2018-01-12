class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-3.0.6-source.tgz"
  sha256 "9700bcc440d7a6b16a49cbfcdcdc31db33efe60e1f5113774316b6fa4186987b"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b5982b4db77bed26abf0bd6d8b74c6d810186cb9a65aa8a40cfab43b5aae06be" => :high_sierra
    sha256 "55a78d2e8462a06529a52db2611b8b6a5a5b77eeb0bde61fe0720c1621e219a5" => :sierra
    sha256 "234a6a6da631e0a947498dc490b2770e3fac1ec8d5b63b49190050a7be11539e" => :el_capitan
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
