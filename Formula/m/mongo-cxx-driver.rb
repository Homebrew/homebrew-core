class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.4.1/mongo-cxx-driver-r4.4.1.tar.gz"
  sha256 "8775b338b28e3a7ed57bc0dc8d5442a43e94edd0d4853c0575fb7082bcae7c9c"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1185832470faa66945948904a7a9142e5bdd5bbcf6eed1c9d09111baaf0cbf01"
    sha256 cellar: :any, arm64_sequoia: "ba6594e9f6abf6b4f35e259c29b6eb51c23fb75677188c74a1e6b205cdd8ce5d"
    sha256 cellar: :any, arm64_sonoma:  "4741fda3524ac26e704ae92863dcd7a21387f1e8fc9e8349c644c6f6bad679a5"
    sha256 cellar: :any, sonoma:        "8c5e62e7fee9a39f9327bcdc337cee0f4ece1d8fa54ed2700c01c6012b0f3a3a"
    sha256 cellar: :any, arm64_linux:   "3fff516288565d5ed86bad73e9805f40990c9be5bbe0a12d56d79485be7a4da4"
    sha256 cellar: :any, x86_64_linux:  "ceaca9eb69f3219c3e8ee7435577cba333dd90c44be32e2c0db82e62b25ba447"
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
