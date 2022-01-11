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
    sha256 cellar: :any,                 arm64_monterey: "17f4f32b17f3b0336f74f2fa86f5276ace4b0afb7b84e509836ff47f72188ff3"
    sha256 cellar: :any,                 arm64_big_sur:  "6ca22d722f78238c30b5521b350ed60691d6ac8765d83cfabe45ca43e5f56ea9"
    sha256 cellar: :any,                 monterey:       "676413ef23ae0a544a5a526bb4296aa14ff7ddc805526f6b75607bd4b7f6271e"
    sha256 cellar: :any,                 big_sur:        "68107a309bd102ca33867b07f715dde2ea30e961fe83406bdfb2a8ec9665e1ef"
    sha256 cellar: :any,                 catalina:       "f19bd77bd94525ba0c0f7d2b05c415b99779bec59ee147f5ca2f763c89881f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a943e7b41a9c95b3d42b7a31cc47aed783cb8cd4f3c5cc0904a9a69115ae20c"
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
