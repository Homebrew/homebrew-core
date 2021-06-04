class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.6.3.tar.gz"
  sha256 "bdf6033ed23df0cdd8c6e1e45cf6dfa63c9806893718eadfa6574cb25b3183a8"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "2001fcc1bd799e85ab0c11413b4ab5f54085865dcd61ebabafc2a16420c180bb"
    sha256 cellar: :any, big_sur:       "a9ad2cec34bdc0356cb820c59531505c9b9978451b73b16b13df602e34e630cb"
    sha256 cellar: :any, catalina:      "cc4fa2875ee2ec4043742f3601246d3c301a4d0f745442d8c8728cd700c3f77b"
    sha256 cellar: :any, mojave:        "09281cacfe2cf4c49e0f171ae2c6a7c571208f07afb599bf5290135819849852"
  end

  depends_on "cmake" => :build
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = Formula["mongo-c-driver"].opt_prefix
    system "cmake", ".", *std_cmake_args,
                        "-DBUILD_VERSION=#{version}",
                        "-DLIBBSON_DIR=#{mongo_c_prefix}",
                        "-DLIBMONGOC_DIR=#{mongo_c_prefix}",
                        "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make"
    system "make", "install"
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
