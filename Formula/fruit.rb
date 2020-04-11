class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.5.0.tar.gz"
  sha256 "1e1f26fb2ec100550e0e29ee0f4ad0df9f7a8144a65c0b9cb9954cd2e4d6a529"

  bottle do
    cellar :any
    sha256 "e635411e7c64117269f45dc3ea642fa6bb7460b206490d31c481ee66a2d61b0c" => :catalina
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
