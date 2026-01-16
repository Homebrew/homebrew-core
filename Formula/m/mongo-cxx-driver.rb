class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.1.4/mongo-cxx-driver-r4.1.4.tar.gz"
  sha256 "c6edd29b7518cc123ae11a926c07f3c968a683190a2fcf5c7082f7dd7c908077"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f889faef629d572c7aaa3681d63e64c99069b1cbbaf48c931c4ae4723c4e621b"
    sha256 cellar: :any,                 arm64_sequoia: "482dea590c6f2f3bcb8d3221738cd80898102a7f395de64eeac53fc7ccf4e6d5"
    sha256 cellar: :any,                 arm64_sonoma:  "14326266c4231c1b740cb51a6d04fa59693560d6cd0ca62df9902b162170b0a4"
    sha256 cellar: :any,                 sonoma:        "255735fbec7bfb69f57596333bbee4563b04551034ed3357d57021cc5fefb368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27362daa574fb6b2eceee044dc8854aca5881ed74503ed25ed9239b93056c02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c09e9f0f6f29162b617c36265e8ba95f970d997a0f9510e8e914d77652cfa9b0"
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
