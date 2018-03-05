class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.2.0.tar.gz"
  sha256 "e26edd44cf20bd6be91907403b6d63a065ce95df4c61565770147a46716aad8c"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    sha256 "b12a8b6566b88131477f79a84bd75a2145ac8545da8262966b2d2df6e750c76e" => :high_sierra
    sha256 "7ad27f3653c9918154c096f0c00c0e0d70289817a81ad11c84f17850ea0f774b" => :sierra
    sha256 "96e2986f43166c5f54ef62a7dc36dc007a5e5a63057b9bc05d23b2e4ff53e2f0" => :el_capitan
    sha256 "514fbb37aee0e2cb3d72c8a31e984e8be6bd5308081c1051598f9e7efea543c9" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "mongo-c-driver"

  def install
    mongo_c_prefix = Formula["mongo-c-driver"].opt_prefix
    system "cmake", ".", *std_cmake_args,
      "-DLIBBSON_DIR=#{mongo_c_prefix}", "-DLIBMONGOC_DIR=#{mongo_c_prefix}"
    system "make"
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    mongo_c_include = Formula["mongo-c-driver"]

    system ENV.cc, "-o", "test", pkgshare/"examples/bsoncxx/builder_basic.cpp",
      "-I#{include}/bsoncxx/v_noabi",
      "-I#{mongo_c_include}/libbson-1.0",
      "-L#{lib}", "-lbsoncxx", "-std=c++11", "-lstdc++"
    system "./test"

    system ENV.cc, "-o", "test", pkgshare/"examples/mongocxx/connect.cpp",
      "-I#{include}/mongocxx/v_noabi",
      "-I#{include}/bsoncxx/v_noabi",
      "-I#{mongo_c_include}/libmongoc-1.0",
      "-I#{mongo_c_include}/libbson-1.0",
      "-L#{lib}", "-lmongocxx", "-lbsoncxx", "-std=c++11", "-lstdc++"
    assert_match "No suitable servers",
      shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
