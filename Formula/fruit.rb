class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.6.0.tar.gz"
  sha256 "b35b9380f3affe0b3326f387505fa80f3584b0d0a270362df1f4ca9c39094eb5"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "ce25f8c98746ff3d17da1f0c594cbdbbc8cb212647dde4ca3ea6d8e3943f51dd" => :catalina
    sha256 "88f0ff518dc1322730d89565ecc2a1dbc2bbe2f8048008429a48c44652695516" => :mojave
    sha256 "61eb9de4c90462f2feda154f0a08297d461ccf7f7875269aca04824180135c22" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DFRUIT_USES_BOOST=False", *std_cmake_args
    system "make", "install"
    pkgshare.install "examples/hello_world/main.cpp"
  end

  test do
    cp_r pkgshare/"main.cpp", testpath
    system ENV.cxx, "main.cpp", "-I#{include}", "-L#{lib}",
           "-std=c++11", "-lfruit", "-o", "test"
    system "./test"
  end
end
