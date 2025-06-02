class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.36.00.source.tar.gz"
  sha256 "94afc8def92842679a130a27521be66e2abdaa37620888e61d828a43fc4b01a2"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3939bf78dbe26a47859003be209972a2a61fd60233f5098191e9b373f17bf35e"
    sha256 cellar: :any,                 arm64_sonoma:  "5f8cbeb5418fd74de128cb842c27d90556e227d3ede48abf9b7927271d0262ba"
    sha256 cellar: :any,                 arm64_ventura: "842924cac1d8382ab920397e43182019170666a6ea2c64227d12d768f1651d4a"
    sha256 cellar: :any,                 sonoma:        "222595e6eb0bf2a8509dc9e1ee4d394eecaebf85769ae9fba5531264b3de83f9"
    sha256 cellar: :any,                 ventura:       "7b306a0065575cbdb1e596a72c975b113eeb6033a8568c64134b0f832b955d0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e25ed8a8b20567579be4d88c4ff07769a36c3716012b749250b5e383d9922f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6edf08934a7aeaa519e1048df43d90e40b0a3bdf592a8d25e0e4a6cd0ef9dc5e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end
