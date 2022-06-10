class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.10.3-source.tgz"
  sha256 "a87d59ccea596d493d375b0d6bc380079a5e5a4baebf0d3383018b0cd6bd8e33"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "95527d0d3be0253c37b54a4410ade7e341168dee2d8ff544f91ed5f2dc5f7ae0"
    sha256 cellar: :any,                 arm64_big_sur:  "6334b05cb47bf8fe6f2eb016e1519f6309f37458a2dfef093afbad39e5525a2d"
    sha256 cellar: :any,                 monterey:       "1b145d4806b2888f848c216885ab3f626fe6cf98a4acf0c2e1cdbedf24286622"
    sha256 cellar: :any,                 big_sur:        "aa210095b49800aabf4d841a51a632b98810e9a1a0480264e3377b98662a0337"
    sha256 cellar: :any,                 catalina:       "fea26e00e1b778a865c394af7f2209c416acf62a2109cc82665ded5d979ff086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5902867ca73e7698db5c0c35fccfb651ad12817bdebf8d6616af473331c6386"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "jpeg-turbo"
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
