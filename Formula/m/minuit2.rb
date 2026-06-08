class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.40.00.source.tar.gz"
  sha256 "676f8fde8926ce05902be7f44ce7d492a4a2060022fcab0e3d1c44f6dc0fbde8"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9aa7a1f85d57ca601a02436acb6a96e67bb9f4b6f7cc7baab8d5d077b7295382"
    sha256 cellar: :any,                 arm64_sequoia: "2c107e35c37e5f8ca47462391111188a06b0d4fd522a2843c554823a332fd5cc"
    sha256 cellar: :any,                 arm64_sonoma:  "5a288fc91edbff975b071f720513ecd5f1270cd909199ba1c1f5260b44a8fd0b"
    sha256 cellar: :any,                 sonoma:        "804d9df81e3dde8a0552a49a97a715e02e48b727d912b7bc1bb3a45e9d670f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb15a622b794c75f6f521003e8273f3c04cf819b9bd943e3ac4b91443ce6976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23d51c99791c20bf97c3e131c33f6dbc26fa102b1a741eabb73ce68b37e91dc6"
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
