class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.40.04.source.tar.gz"
  sha256 "44ada253b1935d34b6801222232d50731fe7c5e3cbcfab47734c85031cfbe4d3"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "56481a57eac7e7c84f56026b5ab780d02e170c6b95a7ce603c2e06d4eaeff4be"
    sha256 cellar: :any, arm64_tahoe:       "5b42eee0e3c7cbeb2d1bd99b7fad530ea979de0f5451ce5b2475ce0d8dfe281e"
    sha256 cellar: :any, arm64_sequoia:     "29ac8bb3fd9ff98a216c2eb181c8de0e454cc5fe1a3893aa9b5140b550856f39"
    sha256 cellar: :any, arm64_sonoma:      "f14bc00bcb166adfa4431e152fe3252b5fa2d041e8d844f077410c9ea25801a3"
    sha256 cellar: :any, arm64_linux:       "0b206ef5b8e5a7d784ddeca32b842ec91b8bf12e23e5c2dc23052e8a4c612b40"
    sha256 cellar: :any, x86_64_linux:      "f8aea9c171d574f69115878ddf2026d5e0617bff097e4360b75feec82bfed40f"
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
