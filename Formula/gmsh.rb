class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.4.1-source.tgz"
  sha256 "853c6438fc4e4b765206e66a514b09182c56377bb4b73f1d0d26eda7eb8af0dc"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "28e6d53b54a18a7cbe1d8667e78c122aa9a6ce88b0873ae17011b87885e12e5b" => :catalina
    sha256 "0481ac18b7fb27296d18d6b2991a1900f4a156127b1be31d68151ce0ece1ddd9" => :mojave
    sha256 "30a4b910905200d7eba39d1cc311bcd82cda4fb5c249502083097a82ec472d90" => :high_sierra
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
