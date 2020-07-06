class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.5.0.tar.gz"
  sha256 "2a61369e616c4c08310586c339a27bddee0482305e1dcc83ce08e3529cfa5b7a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    cellar :any
    sha256 "dc2851f80300a7e98efbca1943ed38ec8041af38443558b7e45273add8de9695" => :catalina
    sha256 "d02839391a9fcd20c69442be2bd00a7c23bc604e4b1ce7828b7f9a4596debb66" => :mojave
    sha256 "0b14ae6bcc3279d9257b89c8b5e3508876f8adbdb7a9bc67bff1f988ba7f0ee2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "mongo-c-driver"

  def install
    mongo_c_prefix = Formula["mongo-c-driver"].opt_prefix
    system "cmake", ".", *std_cmake_args,
                        "-DBUILD_VERSION=#{version}",
                        "-DLIBBSON_DIR=#{mongo_c_prefix}",
                        "-DLIBMONGOC_DIR=#{mongo_c_prefix}"
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
