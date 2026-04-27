class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.3.0/mongo-cxx-driver-r4.3.0.tar.gz"
  sha256 "64722a58ff4b8b9c248cb85225ebe6c59fa6264fb97716b470858ebab8271c11"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "75e1fe614763351127335519c89bf2fbebd8aa16283da93c87e4a93fe378d80a"
    sha256 cellar: :any,                 arm64_sequoia: "c81128d434eb0ff036578f50fa6f2786d006f3ba0d0ee5b727bbed8a50e0dbd2"
    sha256 cellar: :any,                 arm64_sonoma:  "58a3e8ff017d8721e4389d12962534722fbf0dc12f12e1fbcc3d6b4173bad90a"
    sha256 cellar: :any,                 sonoma:        "945ec8f9a7330aca99b8786ca33b40b9ea07f07c1388238803ad282be916d806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa0098df2f18e4bd81b05023f7d97cf4c0b85fdf0cea327ec608329e8730400f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ae4fbe0b91e7168375e5a1db6a1f1bfe5b0264a0158ccf82696703c040d04e"
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
