class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.34.02.source.tar.gz"
  sha256 "166bec562e420e177aaf3133fa3fb09f82ecddabe8a2e1906345bad442513f94"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f988cb91cc6cd097ecfba61926ec86df20c78928e7501a0594468519cd0496d"
    sha256 cellar: :any,                 arm64_sonoma:  "0e657972e4247529a2a303fd09e65bafc856fb5b4172eb382da7fbd22bdad7c6"
    sha256 cellar: :any,                 arm64_ventura: "0d804ad399b78bd5324c24e18749e43a4617588857c70be0a03b3ab5ed89d123"
    sha256 cellar: :any,                 sonoma:        "3074477ef7e3ee125684c157fc640d97ed81ce755b28823f138822279ad5b59e"
    sha256 cellar: :any,                 ventura:       "158e2490020c9e32d0197af372c2fd42b9e1a12f30dfae2690e188dc8eb256d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98663275ae956398b6fd5c34f03dd9bc741dc051cc2202144d3a9dec31df4a7"
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
