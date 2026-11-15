class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.6.2/mongo-cxx-driver-r4.6.2.tar.gz"
  sha256 "db3d963188af6ab44aa6c1ba9b4d9cd777933c2726a1ebe88a7e6884980e2cdf"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d28d13f495205a4c29e13cbb411ad1ff03cc51660799c4102292a8cb21071d1a"
    sha256 cellar: :any, arm64_tahoe:       "d3f6f990eb1ab164f46f802d3453152605bd51653fc53dc3f11f070b853bd7ab"
    sha256 cellar: :any, arm64_sequoia:     "dbc951063d68240b5b303091c5690c2d853c0fe0be03721e6a7d24b8b57ee10c"
    sha256 cellar: :any, arm64_linux:       "623db8e8afb4fdd9bda26a53ac9b750fa098dc50677e669f53b3f820051a9f13"
    sha256 cellar: :any, x86_64_linux:      "f732b2a0ac8c20dbbc034ca96e71ea503b39f4ca7f5410adaaae0885bcf5b5a0"
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
