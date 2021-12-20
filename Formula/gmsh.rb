class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.9.1-source.tgz"
  sha256 "617836aaab53cb1de2963799ba55d9af3377dd610cc8605aa57532be271074d5"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "bae73b509084f7dbadf0e50f566cef1275d1e1ce343f556994474d979ce13a4f"
    sha256 cellar: :any, arm64_big_sur:  "6c67fa550d5e9d1dfe7d688e8d79f52221c97face9b604806926cda3d12bda05"
    sha256 cellar: :any, monterey:       "cdb0739ee040cc1d543690179833deb53b8801242ef6e7901dd71662a1163297"
    sha256 cellar: :any, big_sur:        "c59269d9afca414090382ef66a2595c5028e865a32c8cf59f47f20f921a46fb8"
    sha256 cellar: :any, catalina:       "b582d3e4e4492bac6c1d4b749ef3b681401ab6a7b2188e8f65d8e3b67bfb3bd2"
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
