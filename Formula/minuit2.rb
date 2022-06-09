class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/md_math_minuit2_doc_Minuit2.html"
  url "https://root.cern.ch/download/root_v6.26.04.source.tar.gz"
  sha256 "a271cf82782d6ed2c87ea5eef6681803f2e69e17b3036df9d863636e9358421e"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "185a34231da8d53de0b3c1ab9ab815ba6b26f7e804fba82399b1d024dbc6858d"
    sha256 cellar: :any,                 arm64_big_sur:  "f2734f9437135a9ac1f53f4d465c6385d360cf2adc6af5be7368c076a4566ecd"
    sha256 cellar: :any,                 monterey:       "f8a0a3e9bc4e0effdf005c10564171221797d7d0caa3ed820340193aaf5da63a"
    sha256 cellar: :any,                 big_sur:        "ffb7d2396bd3cc7c307c1c1258b7000816b571580515adfb88dfcad2570be8a0"
    sha256 cellar: :any,                 catalina:       "30de75ebb11bc6f8fa2e9d092a9368c46caf712fe8e8d7deeff7752d27decf52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47905da3a5f6d0ee101b991eee1972b32cbe5f3bab2da26c10e14475370eeeff"
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
