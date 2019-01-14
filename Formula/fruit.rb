class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.4.0.tar.gz"
  sha256 "0f3793ee5e437437c3d6360a037866429a7f1975451fd60d740f9d2023e92034"

  bottle do
    cellar :any
    sha256 "8f356a4344088d420b1f1b3b4bcd2cc922ba5e24e6b0a4f3665d670fd75f4410" => :mojave
    sha256 "913b406c8a33b0b02726f6ffbe1f234b7889c0125655b223d81c4c5234f3b7de" => :high_sierra
    sha256 "a148ef9a9b71fb8c038d4a2fe16f92bfb6c2c7220d63eab2f9959e5d24688dcc" => :sierra
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
