class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/r3.7.1.tar.gz"
  sha256 "79f9ae3fbd960354127c8bfa3035e34df6fd436991f9298c53d60579e96552d9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6057765830eea5a90d30d75b2a0c4ac6ed186e1a212159d656a3478a19d5e2f0"
    sha256 cellar: :any,                 arm64_monterey: "d67ecd7b2a2cc7bc2692ff085fadd9e21c45ae38953e894045255849ef5564d1"
    sha256 cellar: :any,                 arm64_big_sur:  "e555552cbc5b61f3df2465186cc73ff7559d659b1f1f851b286365e056fa2927"
    sha256 cellar: :any,                 ventura:        "94be782516a364559e8c10ecfd977c3a087015dde8597236c1714d493a8de647"
    sha256 cellar: :any,                 monterey:       "afd50a2bbea26f61909d5b280b500ab76eeb72ad6adc110a1ec75a078e021ccf"
    sha256 cellar: :any,                 big_sur:        "baa6e389b7fdc3e6553106b212819e7c921c5abeb51a0f9d83a858768b2f5a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74abbc8f5c1195d2572d8f6df8d8406f4ecb335bef71481def78d71522ad3f3b"
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
