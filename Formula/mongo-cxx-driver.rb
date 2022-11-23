class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.7.0.tar.gz"
  sha256 "dbe9e2e973d234ac1acd1bdb2581f960b72b2a753a5cd13b7be5d5cdd8e63791"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1a266a5e5bcb49f02ddccd01e9d897818ccc75e83583937dfe7e3bc5469356e8"
    sha256 cellar: :any,                 arm64_monterey: "b22ea18ed39feea803ff254ac391b126666093433bf8ced6f3b892b9bb0696e0"
    sha256 cellar: :any,                 arm64_big_sur:  "9f144209a2a648a896fc1c536c6af0c16c5eaae5ec89ec079da6281aeedbd285"
    sha256 cellar: :any,                 ventura:        "aa6a954c9a8e214fda29452ee1e1772e88dadc448377a1f7ead5d8f34a7b6143"
    sha256 cellar: :any,                 monterey:       "7824d1126e6e82dd7d595e63ff70eea04de9ddb17a5f5716286ca95a934b627f"
    sha256 cellar: :any,                 big_sur:        "7d709a6509b33e5c8803345ca215f7ef0faddbbabc12ca55937eafa2dc44bf6a"
    sha256 cellar: :any,                 catalina:       "ee5c42f7d8323a37a758a81eeb3b3b8431fce82c251deadebb2c2663b454885c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2c68e11dd9527a92912c516edd615f579f20286bcdb9a34500cb9b101a4972"
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
