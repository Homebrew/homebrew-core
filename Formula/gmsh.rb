class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.10.4-source.tgz"
  sha256 "f47e927f24f354f38d44e26c21a2495c4cdbdc3d5eb9b883d5a7e3a2273fbd13"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5cd5cdf4f33b1a1a8dbac20fe5ef74f3b24b29b3f325651b02bf8d302bd30e35"
    sha256 cellar: :any,                 arm64_big_sur:  "9e03ddd0fd06badb1b7637e111fbf54a1d42f5b3f9c5da19a0ee4df59c780a71"
    sha256 cellar: :any,                 monterey:       "88b4a4b9a33129ffa48acffc4419abd2a3d9534f75bfbc898450e7e084e9499b"
    sha256 cellar: :any,                 big_sur:        "2ab0282b5caf2f60c4801ad5f4d5bc57b8406de749cc9d24d238c2d8ca66cbe9"
    sha256 cellar: :any,                 catalina:       "4f2e6aa420446e211884b16f8120b31cf28cccd0eda4931e053244e789893146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85778a90f96da9ed38be301eab364472ba0338b9e32b7cb4cbdf8830ab333566"
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
