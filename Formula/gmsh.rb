class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.9.0-source.tgz"
  sha256 "b8ef133c9b66ffe12df1747e72d4acf19f1eb1e9cd95eb0f577cbc4081d9bea3"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c7de949241bd3b5a29cb6e2615282574cc22c30bf5c9f731fcdcdaa140f124f6"
    sha256 cellar: :any, arm64_big_sur:  "e14165656cd32d0fba4cc400a71bb2e79a70acd18ef2ef94186829addb129f4c"
    sha256 cellar: :any, monterey:       "68df0c59dab7a269e8de9fffbdba1335f25c62e2a5fdc346abc738dc4f12dcfe"
    sha256 cellar: :any, big_sur:        "8a23c9c50c44b3cb149910bdedd76fd55bf466a445c96a2645177ee745b85301"
    sha256 cellar: :any, catalina:       "8757c1a3e4599bababb99cf54d66cb45b3a820357beb59f8e7f75a0c3b305dca"
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
