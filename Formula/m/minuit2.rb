class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.40.02.source.tar.gz"
  sha256 "f631eebee3dbea128f1415f4b784f5e83637a2b431193bce75f10385f71efc56"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef68fe1ba7d43d170a5358cded925bccfe6cceb4292fa446c4c4555a26c490a1"
    sha256 cellar: :any, arm64_sequoia: "d79b38cc0ba70b05a113fd20fc6807ae11c44244f40156c220175a77695d6573"
    sha256 cellar: :any, arm64_sonoma:  "9f834f73d9915a2f062bb272a3c52815bf19df044011f9f7107290f0584ae765"
    sha256 cellar: :any, sonoma:        "43ec264a53311f3e9a2e20c68a85ec784aa5b922e111a672633a84824d765b64"
    sha256 cellar: :any, arm64_linux:   "56a8baec56d5854ba54bafe3f73e2bf5e035c9adca14eb9fabf9e62e7dcf70e8"
    sha256 cellar: :any, x86_64_linux:  "df5355a064419cb52cca303571bc10f825aeaa43fc3a75a66b008e51d7e4297a"
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
