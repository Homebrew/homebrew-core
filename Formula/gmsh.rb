class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.9.2-source.tgz"
  sha256 "dba281e033584f5da07e2d98d7ae7a3dc481723cb26c2c727b65fc20b301618c"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "02df3de9a070afa6082a284a66b9ab7bb78891bebaedf756aa6d463afb4bed75"
    sha256 cellar: :any, arm64_big_sur:  "ce714dab447c33a45792287235c02d2f4ddfb9b938fbdf703877f7a528cd3972"
    sha256 cellar: :any, monterey:       "dac87a8d7c9fad1cb04d0a6b46701163f780910e9db8b2fd08decee03714f912"
    sha256 cellar: :any, big_sur:        "8f439b3eaf4bf8d030588de19182cc79947627fedc388333dd85a81e7f3f5517"
    sha256 cellar: :any, catalina:       "8f52977429c810c879813dff61fd21425cb1b49f52dcf657bdea4f43d8b7cd7c"
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
