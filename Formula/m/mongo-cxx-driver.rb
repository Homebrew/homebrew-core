class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.10.2/mongo-cxx-driver-r3.10.2.tar.gz"
  sha256 "52b99b2866019b5ea25d15c5a39e2a88c70fe1259c40f1091deff8bfae0194be"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5157d79d387dfb72fd75b6f246f4d803d1efd6de05c7863d0a4b935cc3facabc"
    sha256 cellar: :any,                 arm64_sonoma:   "c5f1935ab6adb6c7470003904987c9fb22ca00d4757c1d1528a65136b29f986a"
    sha256 cellar: :any,                 arm64_ventura:  "1b23dac19617ef1caaa94e967757e7d7088200d8e2c94c8d16f6bb83b204ceb2"
    sha256 cellar: :any,                 arm64_monterey: "e7158d2d8573f406ebeed69f0b697225a29424459e8f5d9af2ea64b59fe96b9c"
    sha256 cellar: :any,                 sonoma:         "592c68556b57567ba2461b8827254cb9830ad935e5bea3804e4b7de4885badbc"
    sha256 cellar: :any,                 ventura:        "b0b1c37736dc7482166aafdcd9b238710c6262ed83b1aef1746193b20c636188"
    sha256 cellar: :any,                 monterey:       "0303a5d8d299b1c29ae24aa94f58db6f643b5bbb15d6f68b4fc8411838ea6c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4852dce8fa374146a015501e8e9d41a6f3465d5b8e7bc8f6d88168d958ba518e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
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
    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx libmongocxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers",
      shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end
