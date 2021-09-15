class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.6.5.tar.gz"
  sha256 "80f0e9d1e8cc46559b68d571de91e86193bfc8042afe955db081f810d38134e4"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "420a8d7b1a441550ba00b2b29c336932527a38c6190747e7eb8e3144ab2eda2e"
    sha256 cellar: :any,                 big_sur:       "87df7b24f526a69518b53e40c08e01d2b97c049f6ed6e8dda4896584681cc923"
    sha256 cellar: :any,                 catalina:      "6ea86cfbed1987bf3220c501206777b1393ddc939146ada8171365200518d6f4"
    sha256 cellar: :any,                 mojave:        "e9ef0c9f9b7db18b26d6bcbe033748d072b614c4994dd1894eb06854861df6b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3064f7f342547011ebc777a76b4efbafa30af18b1a62f1899376c7cad3e4d7db"
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
