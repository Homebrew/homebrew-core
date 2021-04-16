class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.8.3-source.tgz"
  sha256 "26f248b129a00d1ea0658f024410c2490bcd9de724545a1144a092c604276775"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5e2a01c4dcc89ad08d22b52e035348de870de7dce3df929483b1d62e189ab98e"
    sha256 cellar: :any, big_sur:       "74c50799f197a99043c69d6ccc57956fb833aa0a2afc1957a144fe1b0a76faa0"
    sha256 cellar: :any, catalina:      "fa0ac31134b06b06d7b017c527ead99107a09062d12c36b515748f30fcfbfe83"
    sha256 cellar: :any, mojave:        "3e16f3d507c7b61e30592c152c4b66d361be3b00ab001db868b90a91b2ed6b79"
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
