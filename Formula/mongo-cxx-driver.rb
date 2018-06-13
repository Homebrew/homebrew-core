class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.3.0.tar.gz"
  sha256 "22857d0985039ca1bf77b7c709d4306a4d0728e1f839eccdb439415f1b26e199"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    cellar :any
    sha256 "2de8e512c9b26c6a36b2ef3f243868db329902215dbff9aa230f3362806d3ab2" => :high_sierra
    sha256 "65e1ca03d1c508a5b159ff321b6e22ac8637151c6abd3215683fed8abbb6a1b0" => :sierra
    sha256 "6927866e96e55929e97cccc889c1606387a056c1ec3cd83fab28343db83548bb" => :el_capitan
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
