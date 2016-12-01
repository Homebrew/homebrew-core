class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.0.3.tar.gz"
  sha256 "297957788ed6f8d32ff05cf1a92f022aa4e3cd4398b0c2a0d4a2434363fbde6d"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    sha256 "2da28be00a98eccbfd8450107272cb30fdfa26b2c8a26337cb9a23198fcd19a1" => :sierra
    sha256 "9c6a5c8ba973e5ee7c2f33129b024677ed53458869ff7748c44a8c99d2c08b52" => :el_capitan
    sha256 "a2035b85eb66845f4e064e2e41dc7eccffae0bd9fcb25192041558983a4ebf19" => :yosemite
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
