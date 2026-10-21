class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.6.1/mongo-cxx-driver-r4.6.1.tar.gz"
  sha256 "1b88828590e54d07e4bc073ea9c2e4d11d72d50a6bedf3faea992b89efed980a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4d33d898cfa8a23b867488bfb1577eea919f0958ef4a7951d533fd32fd7ae843"
    sha256 cellar: :any, arm64_tahoe:       "e1c58c98c31844244f8d7dccffb36b94d66011b7dd75bb28e947b52ad8396b2b"
    sha256 cellar: :any, arm64_sequoia:     "cfa3db951aacd8a8db9553fe8126175b6cd001fd66218a4322f2e9e699c6f726"
    sha256 cellar: :any, arm64_linux:       "e09ad7ae197a858e6692552481fab18ae13ff86a90cfd27d7baa341ba8779daf"
    sha256 cellar: :any, x86_64_linux:      "0cbd03202331aa0eeed53734ade6336cf5ca77890593cabbd8db4049bef4f542"
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
