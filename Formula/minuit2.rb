class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/md_math_minuit2_doc_Minuit2.html"
  url "https://root.cern.ch/download/root_v6.26.00.source.tar.gz"
  sha256 "5fb9be71fdf0c0b5e5951f89c2f03fcb5e74291d043f6240fb86f5ca977d4b31"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "28baba24aef52eff45f8411d04bbdfa795dcbd9cc4c9d9c71f9eb71213b60ddd"
    sha256 cellar: :any, big_sur:       "92436bedd07967e01f4b230599680a6fc8220c43d6ee377aca4e7d824aa4eae6"
    sha256 cellar: :any, catalina:      "94d14435083239aeca25cc36037c4c1445d7327c9e28f216dfdbcb3be16525ec"
    sha256 cellar: :any, mojave:        "19ea9f2a3b94afe2902e02a71281d85268c5e63c46c9df822d9ac138211f6cc5"
    sha256 cellar: :any, high_sierra:   "61b38bc01bf0744908bfda8e610ca39f7f07b4e2d6ecd1239cb0de82521ae375"
    sha256 cellar: :any, sierra:        "00867c4037d0110f2adf23a623aa918a95c9345be197ecdc0a9aa0d9da9f04e0"
    sha256 cellar: :any, el_capitan:    "7457852262758583daca3f23ac3e6fa312fe0a3fd84f0b20da2081967124a0fc"
    sha256 cellar: :any, yosemite:      "32ff2d05e0a85b28513789e1f625e654f2141b80202f506ad0f7721caab95ddd"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++11", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end
