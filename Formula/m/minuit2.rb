class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.38.00.source.tar.gz"
  sha256 "a4429422c460f832cde514a580dd202b1d3c96e8919c24363c3d42f8cf5accdc"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c60bfce17432f7a41861f5e08a2869779abb5286404991e30aa92913edd7dc63"
    sha256 cellar: :any,                 arm64_sequoia: "552e9a7d920bdac91c76c28c506439e5b0f71383dc80d423c08ebc6239acde10"
    sha256 cellar: :any,                 arm64_sonoma:  "2e5caeed22eca8d0bf3d97522a6ddf89f69bd9dc9010139bec062b0056994b96"
    sha256 cellar: :any,                 sonoma:        "b58d4263ba462cada2c99a182aab9571095a47cb65e4ce265a4f6edf6c5da06f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571f3383bb7c044e752d46f3e61c0bc6dec91869480c38bfdeffc70a6a77c344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7824816ed13499edcbb140fb8e9dc43d6fc02988e259ec18977208bccac37b"
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
