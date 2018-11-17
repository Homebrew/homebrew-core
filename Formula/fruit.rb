class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.4.0.tar.gz"
  sha256 "0f3793ee5e437437c3d6360a037866429a7f1975451fd60d740f9d2023e92034"

  bottle do
    cellar :any
    sha256 "01b77df0ea53c6672c766f464b753583ac530f6f759cc74c0235e3b2b88cf75b" => :mojave
    sha256 "68d203232c339e922d31b8202abd16d2548bab5fdfbe4ce1167822adc8ef1b00" => :high_sierra
    sha256 "41d0398cabe780492baaaed4d04ab18f30a880d8ef5a951a8c3b7c8aa24ce4af" => :sierra
    sha256 "5c1ec3722f8337844cd19ec5fa3f53005fbfb439ab65e2b704ab882df9b9a921" => :el_capitan
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
