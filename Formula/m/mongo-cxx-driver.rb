class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.5.2/mongo-cxx-driver-r4.5.2.tar.gz"
  sha256 "f76d133640f1ce6c2e965f054df77bd8427810fabf56f3cf28ef6eaed54c0611"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b94aed39931e2ea08e69cffeae520507db1fa17e7a7860b6fd3997870465eff6"
    sha256 cellar: :any, arm64_sequoia: "34272c93e6f7a58b8407b3558e8a86cb1d61fccd446dc89ccb06cefc22d0187c"
    sha256 cellar: :any, arm64_sonoma:  "21ef31b255002ffeac1e95ef3ea5673f8d07bffc8de928a3f752ca11f908da79"
    sha256 cellar: :any, arm64_linux:   "951babd32f21b65240025c019fee7ad0b6eccaac083cad98b8d645d8387e36c0"
    sha256 cellar: :any, x86_64_linux:  "c6fe09e1ff73743534143df0d2a28e147ea9139006f8397e24e722a5b9aa48b1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = formula_opt_prefix("mongo-c-driver")
    args = %W[
      -DBUILD_VERSION=#{version}
      -DLIBBSON_DIR=#{mongo_c_prefix}
      -DLIBMONGOC_DIR=#{mongo_c_prefix}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx1").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx1 libmongocxx1").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
