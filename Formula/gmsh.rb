class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-3.0.5-source.tgz"
  sha256 "ae39ed81178d94b76990b8c89b69a5ded8910fd8f7426b800044d00373d12a93"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "6b37560da30be4719979285e08e7d0c42199338f6d930b0b9c8c098ac0758926" => :high_sierra
    sha256 "779915c0a34540e3c1ef08de9dae34617536f72984d73ce42dd038f16c5c3ca8" => :sierra
    sha256 "d81123f8ff2dc5da8825cbdbdb60fe10a7b126448bf9666f5fa2745abf255b9c" => :el_capitan
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
