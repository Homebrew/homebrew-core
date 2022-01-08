class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.9.3-source.tgz"
  sha256 "9e06751e9fef59ba5ba8e6feded164d725d7e9bc63e1cb327b083cbc7a993adb"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "599505ebcad73436e7bd7b57efd5f904ef360d0a78000a941fb3965c1f6577bd"
    sha256 cellar: :any, arm64_big_sur:  "c6937b56a0d309063c768e36f25eafb2d94cf90d92b29a97445920b7ec904ce7"
    sha256 cellar: :any, monterey:       "bcf6f5d5f5bc50d6ea53c5b8bd4853a2ee9f00fe5fea1f0fe9d3a78b1c13b124"
    sha256 cellar: :any, big_sur:        "f4873acdbeea03182a750c91320859fc2eabfdbc560f9664318d3bd4c64777bf"
    sha256 cellar: :any, catalina:       "f17ec34d7496c26215a46e7188eee516847309a2f53f10af2ab88e804bf2b2a2"
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
    system "#{bin}/gmsh", "#{share}/doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end
