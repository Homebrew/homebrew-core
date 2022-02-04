class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.9.4-source.tgz"
  sha256 "acff3342d1907c429a4be3e4596ed44f6cd43fd5a94ab75667f4863cdcf2f769"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4aa718a4b7d1faeadcaa874c87e4e4ca2e82da5c378058ce751ac78feb358a49"
    sha256 cellar: :any,                 arm64_big_sur:  "50d6de6b1b0b2fdfcf2e8db39c9f817c00b50f7840efce24039f86bae64ff1a3"
    sha256 cellar: :any,                 monterey:       "9585de98f12992a5333eeb4e96c907f2815dc7edbdf95c525eb586366d401b18"
    sha256 cellar: :any,                 big_sur:        "c7fcff67537fd10502e48dfb2f6c48e260f325532501e407a1a36a0ede42f7b5"
    sha256 cellar: :any,                 catalina:       "40ee85113f84a38cda1b6985fd35d321e91bae762a6eb8b6c51e4cd64f6a19a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f27da0009ee69eb3a6a4068c76ac386aa528251c3236a15578e9a247b33aaf17"
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
