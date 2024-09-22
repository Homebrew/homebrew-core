class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.32.06.source.tar.gz"
  sha256 "3fc032d93fe848dea5adb1b47d8f0a86279523293fee0aa2b3cd52a1ffab7247"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49aeffaff9072575263eb90b99b2420b58936afd647088d100c9e1328f1815bf"
    sha256 cellar: :any,                 arm64_sonoma:  "780a87169e2c08c83bfa182b311f679dc801837fb3fb52b47e1cdcd3a69c4123"
    sha256 cellar: :any,                 arm64_ventura: "81df76464de7aedcebef53166c87db4ff989f1598711c05cb9142563061b0cac"
    sha256 cellar: :any,                 sonoma:        "9a44140aebdc9759f0304d970782d2168c4bc4b849206d66c426a636f5162a39"
    sha256 cellar: :any,                 ventura:       "95995709b388aec69aae024bef400157c10b21adb66d0459c0529ffaf612b4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adbe1fad75e82d7795f079a71136f18304ce4073570b53381d5f69a11efc891c"
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
