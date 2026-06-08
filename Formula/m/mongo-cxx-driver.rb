class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.3.1/mongo-cxx-driver-r4.3.1.tar.gz"
  sha256 "39cbb5010b27eb00b4e947ad5e7d368acd966cd773834a10923d4f008f85b0a2"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "759136a28b6fcc9ff116ca781c3211a70478654092992abc8370362d77b5c34b"
    sha256 cellar: :any, arm64_sequoia: "91963110c13c53f0de22727cceb5d2daddc20e14aff54ed5ce53b5fc68015f2f"
    sha256 cellar: :any, arm64_sonoma:  "2de4202766350c6b8e6f4d671aa9971ca0267c22cd192995b7a2e635b1323563"
    sha256 cellar: :any, sonoma:        "10d16531c7f24eb91ecfb94ad30c14019e7b70708dc5ea020557553a64bb9399"
    sha256 cellar: :any, arm64_linux:   "5a7529b3bfb3e3e1eff4e93ba04c841371e8c0eb75feccb5d2ed5f127f3cce17"
    sha256 cellar: :any, x86_64_linux:  "a20a0c352e2bef1d37a48143593d0d20f1e17b5eed437d4488f57fa09c0cfd1a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = Formula["mongo-c-driver"].opt_prefix
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
    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx libmongocxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
