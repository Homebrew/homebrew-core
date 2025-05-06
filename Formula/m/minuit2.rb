class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.34.08.source.tar.gz"
  sha256 "806045b156de03fe8f5661a670eab877f2e4d2da6c234dc3e31e98e2d7d96fe8"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c446b5ec05217b864c054b6f8446ab5394438bd51a918a494e2eabed6d4f518"
    sha256 cellar: :any,                 arm64_sonoma:  "d28f6057405a99f8370f25bfc008f17d4910cac0ec6a48c6aae8921b85b48406"
    sha256 cellar: :any,                 arm64_ventura: "dc115ea123a1cb40511aa16334a44e6c4a5743e9e23d1b72c87f461da6eedb7b"
    sha256 cellar: :any,                 sonoma:        "43083e3f4fd576122bea19ce2570f7d25faac4f04482e840a294e9e3cba023f6"
    sha256 cellar: :any,                 ventura:       "bbd8a23a4887b10dcdd40faa3f419577f7f207c0fbeeba2969ee11d3dd199659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbfd5df62d1e4014353cee97f8cc5facca727428ae89945b1fae938f414fb373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d252cae913c1d6b222821d159d9ae69d8b757aa3d960eef5f418f469e88c93"
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
