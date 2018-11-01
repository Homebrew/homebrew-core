class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.4.0.tar.gz"
  sha256 "e9772ac5cf1c996c2f77fd78e25aaf74a2abf5f3864cb31b18d64955fd41c14d"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    cellar :any
    sha256 "69ef208cfae61367e8aa0ffa3890a1102d2fed7ce85d030815baf15220274fea" => :mojave
    sha256 "98fdbc9e04c35f3d215fdc1e84a0fc6f41ee50ee8c50fd6682124d1f56e17198" => :high_sierra
    sha256 "5f6c5545d72aeb81fab6c5a1ae2d285f7063d970018c71f3e62c9731b14555eb" => :sierra
    sha256 "4a6132cb86de1ce4bfd2bb171b9a935ae90e8e0d59512a79bffbdceee3113849" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "mongo-c-driver"

  needs :cxx11

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
