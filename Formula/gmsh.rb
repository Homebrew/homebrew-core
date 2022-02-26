class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.9.5-source.tgz"
  sha256 "ffd64900844208719c88d91a66c281889023132b7a9e282c51548cb9f6f3ad44"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f38fbbd2be5f747bd2d9937c15788eed5cb43f0acdbe5c98dc38c7dc26f8fbf"
    sha256 cellar: :any,                 arm64_big_sur:  "18fa3b1c00c5a185852ed937c5b9edd7be051a6c020af2b7ef46751c957c8161"
    sha256 cellar: :any,                 monterey:       "fc233a6e88ef1fdba36fbb88ba2caa3f7e767c0ccddced18019893bc070a49f3"
    sha256 cellar: :any,                 big_sur:        "2328f48aa6b82f596dfaf71316e88fb91f99351d989129d3ca3899d2d5dd5da8"
    sha256 cellar: :any,                 catalina:       "585726ce8e97641cd2da630830975eb4cbf03ec8e7fecdedb9f807e0feb5fd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2296aaf51930c372144d71349aae84427dd117ddd1275733335cfe254424872"
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
