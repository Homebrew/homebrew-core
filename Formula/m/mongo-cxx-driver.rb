class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.0.0/mongo-cxx-driver-r4.0.0.tar.gz"
  sha256 "d8a254bde203d0fe2df14243ef2c3bab7f12381dc9206d0c1b450f6ae02da7cf"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c93c0b4cb94f4e319bcaa7d684ef898443a0b0b02512f00d860637f334bf376"
    sha256 cellar: :any,                 arm64_sonoma:  "2e091b2c5bfa0ed21a67b8c2fda02864183329b83afced303367cd90e2fc2424"
    sha256 cellar: :any,                 arm64_ventura: "24ff232dff402332fdb24ba5ed406f93422ae56613d89e6e34961e1cc8ce45e8"
    sha256 cellar: :any,                 sonoma:        "4786e509bbebf0e1bb24802426d0027463126bfe495958cf0412d70a37aca9b2"
    sha256 cellar: :any,                 ventura:       "acd7dfee17966b718af51c503237001f3ffdd8d1965ae18a6e864a1289e8f662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ae666c8d2a548c041618ab1ccbaf2192f34b49b04855e6cc1161fd4d36e120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a8a48e56b662d49b9ccbb710d7c31ca71860a3a7f716ed8493397e2225d303"
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
