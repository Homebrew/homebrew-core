class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.8.0-source.tgz"
  sha256 "2587783c4b02963f9d8afb717c9954caefa463ea2e0a12e1659307e6a0d7ea6b"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "037ae984d86bc3b119e1e6c6836593491622455cc514b1657f8f770a87d564b4"
    sha256 cellar: :any, big_sur:       "7b1ceb428183176ff47ec15526897cd1a4144ab1dfe59cdf12af3e537aa9cd02"
    sha256 cellar: :any, catalina:      "12869006a60fea19457e778149447dc21dc587ad832b169dd41a32030d52fe57"
    sha256 cellar: :any, mojave:        "6223a68dabbe3dce558c9b41b466e5d377242ee63c88b8a08d2c9b95c28fcc7c"
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
