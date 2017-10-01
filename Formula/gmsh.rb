class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-3.0.5-source.tgz"
  sha256 "ae39ed81178d94b76990b8c89b69a5ded8910fd8f7426b800044d00373d12a93"
  head "http://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "1bb283c6de676400ccfbec34cdd2efbc9dde242ba802fbd24e37488f178938f1" => :high_sierra
    sha256 "c2343c7543ed2212372847968995e0f075d566e3bb8479c1b262b626dfbe2aef" => :sierra
    sha256 "be9749051f061b81c318da178af58e48c6db0f40636c56590d10f4a17f1d88d8" => :el_capitan
    sha256 "e821d285cae69a6772e927cb5148eb2dc2327523bd2e43289f446daf62ce52b3" => :yosemite
  end

  option "with-oce", "Build with oce support (conflicts with opencascade)"
  option "with-opencascade", "Build with opencascade support (conflicts with oce)"

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90]
  depends_on "homebrew/science/oce" => :optional
  depends_on "homebrew/science/opencascade" => :optional
  depends_on "fltk" => :optional
  depends_on "cairo" if build.with? "fltk"

  if build.with?("opencascade") && build.with?("oce")
    odie "gmsh: '--with-opencascade' and '--with-oce' conflict."
  end

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

    if build.with? "oce"
      ENV["CASROOT"] = Formula["oce"].opt_prefix
      args << "-DENABLE_OCC=ON"
    elsif build.with? "opencascade"
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
