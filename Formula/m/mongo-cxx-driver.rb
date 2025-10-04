class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.1.3/mongo-cxx-driver-r4.1.3.tar.gz"
  sha256 "811af69a6ab444410e55fe850d117c142efde49a95f53b9cc4a93a031d527bba"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "baea567c5bb4194d2c836d8ef4ccddbe48468f14b4ec8dde721b21567d78ef8e"
    sha256 cellar: :any,                 arm64_sequoia: "d322b335feb69b9b55b9ccf19d7848cc9b806f3ccf9be70e7a44824d3ada1892"
    sha256 cellar: :any,                 arm64_sonoma:  "840b67be17dd1d82bdfe841d1fbaaf9164c06b72bc76559e12a85112fa4d66d1"
    sha256 cellar: :any,                 sonoma:        "6d22cc1db70ec321ecab46360c08b1fd68d50bdd9e8e29d785d006c5792452bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc17815ad89a57d5efb91b0bdfe12895a52d13dee620d1c6e876fe08effc4526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d685ebf228100918ff85dd81b57fd39d45652245a39f4358a2573b4f8a621d7"
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
