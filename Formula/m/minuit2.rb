class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.36.04.source.tar.gz"
  sha256 "cc6367d8f563c6d49ca34c09d0b53cb0f41a528db6f86af111fd76744cda4596"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "421d499866034e6d09502311618690863a72e93071ef0c09437bfb233a466db2"
    sha256 cellar: :any,                 arm64_sequoia: "d770c3092042f7fbae2c04bc79c1493e215dbacf2a63b2267d5a0f0595145d0b"
    sha256 cellar: :any,                 arm64_sonoma:  "e5019dcab6ee5e75b3197bb8d5f63e67fd034f1b332d0ebb79615322e1fe6eee"
    sha256 cellar: :any,                 arm64_ventura: "f41e7693535109d3bdb53d19711370305cdaa5d8c7fff559eaa166f5f148be51"
    sha256 cellar: :any,                 sonoma:        "1548fb883f376c8e22df42d74ff7ff71c20aa8bfe75c9feffb7463b853d4f23d"
    sha256 cellar: :any,                 ventura:       "07d27a364e9ee8528a930d1cabf53de6cc0df6d20a8461d8cc6d8375f7e71b4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d408452a865e3107a3ec5c5b406aae72e3da576131092a29f651cbfd7257ba30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2e63f0ba845106ef51d9bc5144604a2a0b1f4fe6b342519f9028252051e42de"
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
