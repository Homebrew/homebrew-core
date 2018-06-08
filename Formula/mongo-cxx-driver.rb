class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.2.0.tar.gz"
  sha256 "e26edd44cf20bd6be91907403b6d63a065ce95df4c61565770147a46716aad8c"
  revision 1
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    cellar :any
    sha256 "b39ff24b55319bbb3a3e54e2713081951a65358cc2c3f14f652b882b18eec17d" => :high_sierra
    sha256 "06f4b242a7ee0a78f9cf35bef086dd5d329527d3c3af6c87c65618bf6f3c2028" => :sierra
    sha256 "fe8fce4c6d14e638db3d1a0ce13ad87b5fc1f101f4b81bb8ef2708d42e52c850" => :el_capitan
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
