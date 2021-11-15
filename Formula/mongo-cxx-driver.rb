class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.6.6.tar.gz"
  sha256 "f989c371800458ae45ef69f6d9566e010f9420435a01bf5eb14db77fc024662e"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85b5e04bec351118575d548d41fa4158aef2770bc440896e578e132a997b4621"
    sha256 cellar: :any,                 arm64_big_sur:  "39739b35a1ea90cbbd5d43e9623adfe38088ef5a19e82d2525e92f6128018923"
    sha256 cellar: :any,                 monterey:       "394ea0dd52d96967f199136ab5d2cb29bdedd7a274f569d422ca8ff499606523"
    sha256 cellar: :any,                 big_sur:        "4a4b43266285d03ebc8a084a5c210c97ba845b8fd333eac87f4c395267a6967f"
    sha256 cellar: :any,                 catalina:       "3376ae78c833751b52cce134f6bd1cfa48e13bc267abf9cb09402b8ccef5dda7"
    sha256 cellar: :any,                 mojave:         "9936b280f4bdeffa5f2a50c07e860ca2025ac559b2e33e535e3077f97568576b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bfa9bffbeeea55731cd27d71a64aa9da8e9c9f85e2b54946ff62257f5c55435"
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
