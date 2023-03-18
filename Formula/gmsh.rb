class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.11.1-source.tgz"
  sha256 "c5fe1b7cbd403888a814929f2fd0f5d69e27600222a18c786db5b76e8005b365"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8328f219a8147ed59c2a914dba9bad2416f0103c8da2d4e392ae31206c0e1ef"
    sha256 cellar: :any,                 arm64_monterey: "81a4f86a19b14711a4ffd3cc92c5f27f76ec624861e5e8484a0dd17151d0c0b7"
    sha256 cellar: :any,                 arm64_big_sur:  "0939ec2c63ce60d4c20cd6ee27d061197136e2107f4ea100b0d0349ee3176d39"
    sha256 cellar: :any,                 ventura:        "a5d273c8b3530f4ecf9825a785031a950f54074e143e271e569bead5d94ca424"
    sha256 cellar: :any,                 monterey:       "d68df2536c01f6eec7a9289c41e9352af8892836705f5296f004d0adf3d2996e"
    sha256 cellar: :any,                 big_sur:        "9b19a36a83a4196d644dc6a3831e7914b649af8e08c177326488a52d45066135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a034d2ed6390d1f814d966807f3123a7689b2d179fdf9e7882e87cd6b1b4b7"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_OS_SPECIFIC_INSTALL=0",
                    "-DGMSH_BIN=#{bin}",
                    "-DGMSH_LIB=#{lib}",
                    "-DGMSH_DOC=#{pkgshare}/gmsh",
                    "-DGMSH_MAN=#{man}",
                    "-DENABLE_BUILD_LIB=ON",
                    "-DENABLE_BUILD_SHARED=ON",
                    "-DENABLE_NATIVE_FILE_CHOOSER=ON",
                    "-DENABLE_PETSC=OFF",
                    "-DENABLE_SLEPC=OFF",
                    "-DENABLE_OCC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end
