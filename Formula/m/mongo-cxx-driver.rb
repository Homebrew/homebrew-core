class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.8.0/mongo-cxx-driver-r3.8.0.tar.gz"
  sha256 "60c7a53a0f6b984aab0b231dc0b31c85c8950059f42a354fb522672b059d5089"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8aeb7067e10b2444978bf210240d2f7daa1a2cdd81f0e24b8bb4dfac05c66e23"
    sha256 cellar: :any,                 arm64_monterey: "fbbf780e201cc816c95d8dad326b1d7da725339995911841b29d6210149d6a5d"
    sha256 cellar: :any,                 arm64_big_sur:  "2e35fc41f1e766e5631a160cfdd39ef76d00ccaffd5084c2333c9133f35810b2"
    sha256 cellar: :any,                 ventura:        "d77fde53d0ba4b593b178c9649b9c124b878c06f8d5eabb645516336b16ab22f"
    sha256 cellar: :any,                 monterey:       "6b57cc0b726da556b994776ffd15359df69b2b3eb47fa33b789308cf555acc6c"
    sha256 cellar: :any,                 big_sur:        "69f068e2381e5ea29e00b5e6691a0a568ea56087d635aad5f628b9394cd8eb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9bf9a627e3d6e97ab298a248d9de4adbd5915766fdc03fe35765edb9753aa28"
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
