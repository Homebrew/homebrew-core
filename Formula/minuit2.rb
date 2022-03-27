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
    sha256 cellar: :any,                 arm64_monterey: "4e90ceeb085dd5a51727e74284b9a0301ed6045edf5e8c36e8695827cdd615e2"
    sha256 cellar: :any,                 arm64_big_sur:  "9abea103f5808e82c0b986ed07fa33b7e2b34685349f28069c6b3f8fd311d434"
    sha256 cellar: :any,                 monterey:       "7cb7d45d91f7d7332652ae51face88c9c47f3389e9938818eedd71d35eab3105"
    sha256 cellar: :any,                 big_sur:        "6ffff1de65b77115b710bd343aab967a3ad9c1acc22c1874b41d6e20a105398f"
    sha256 cellar: :any,                 catalina:       "1e1e578c27a43b12f4ae8ff8c73c2d9fb6a95c99f1ce71703753be4fa640556a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7734a89e2357f58d0c8471c2211d5dcda790a46712c0ccb625957ad767a30edf"
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
