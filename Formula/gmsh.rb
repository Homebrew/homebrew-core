class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.10.2-source.tgz"
  sha256 "d921109e6c419f68d5507d9612ee815d40b5239a5db175f28285e0cd0dbf2517"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b459f75659cd2df0ba78b06a7a8e8d5e188170b80ffeb70d2ef19471391b92b8"
    sha256 cellar: :any,                 arm64_big_sur:  "b438fc7507950d56fdfa643d6456a4ea27fde36b6dd445a2120ae172f1aa7772"
    sha256 cellar: :any,                 monterey:       "330fcd934532d1504a4f6cc5f64bd91b1c84a2c30727bb359d7d5a393d1e318c"
    sha256 cellar: :any,                 big_sur:        "21dd1ee4f74baa63ddb21b81dda3acf700592dc99aa347a926d0a4fcbc23133a"
    sha256 cellar: :any,                 catalina:       "b21245f80b909d38dbe21f0213ade215bc67203d5bcffe9a382dacac2c3fd8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19033cb75ac75b55c688d40bf17462e5eb86daa45dbf57ed3f17148256f2680b"
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
