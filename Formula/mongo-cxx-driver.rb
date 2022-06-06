class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.6.7.tar.gz"
  sha256 "a9244d3117d4029a2f039dece242eef10e34502e4600e2afa968ab53589e6de7"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e953ef9f1244187c03e35b5c63cc56fe78a346b6961375883bfdb20882389ff3"
    sha256 cellar: :any,                 arm64_big_sur:  "fe2c413af917d8fbc92cf070ac83de24056be996536f548a15e68378016da14a"
    sha256 cellar: :any,                 monterey:       "58f58441db39bc316d2ff5cfedcdb4d3318c0319b90e8aeb415e72c0e4236fe0"
    sha256 cellar: :any,                 big_sur:        "ae970fe199ed4e7231b1fa8415837b0ccb410773b553d6874d6fe678e1c889b5"
    sha256 cellar: :any,                 catalina:       "89bfe3a25e19f9f35547b5c97f69d012d4bffa8a2197f309f64ba0f3f7cf5832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad20629b2d1cfc86305d17e7932e326bbfd8db3cec28c5a1fc676169cb785c28"
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
