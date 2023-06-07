class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.7.2/mongo-cxx-driver-r3.7.2.tar.gz"
  sha256 "bc0f5193a8184db47a75685b58acd484b0e489eb0476b4d931d1bf4f5fc2186e"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d769f1b53072c19532c0243e28f2968aee913ae5bf6e0aec12df6e9ef6cca399"
    sha256 cellar: :any,                 arm64_monterey: "1b44ab04719e337c4ee764a395f753944b1b9a3b7d87b424e178dd38018b2d83"
    sha256 cellar: :any,                 arm64_big_sur:  "75ec3112d48f622eff5b6e5e98ae309836d1bf264f7cd5ccbc8195bf32cbfe80"
    sha256 cellar: :any,                 ventura:        "2f64a1c8c2fe744ccc0ebab3e4bfea969b101623a382dcb1221cf5c145aebe27"
    sha256 cellar: :any,                 monterey:       "36e763fa33a6b5900a715c16873d5352c15efabf83c9f4a33281df06f40eaa15"
    sha256 cellar: :any,                 big_sur:        "7816b95c0f06043a86b5fdfbe5552e9e465b5343d5ab49449263c2f90bd27657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f06beef02a7b1077edd777ad13665ce972e25388d2dad3776fd5c255396a087"
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
