class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.10.1/mongo-cxx-driver-r3.10.1.tar.gz"
  sha256 "0297d9d1a513f09438cc05254b14baa49edd1fa64a6ce5d7a80a1eb7677cf2be"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2db9749b66b82dcfe4a82e5fa9dd1fa2a1b45e16500d2c0a78be8c22a519018d"
    sha256 cellar: :any,                 arm64_ventura:  "97d9a46ab39a35481f2db04b0445e0897aaf0110d03d6a6611e1d77a153a9e6f"
    sha256 cellar: :any,                 arm64_monterey: "75a8992eb695511faca5af3640967f98198f3a8e403ac2b4397a3d3b1b7db9ec"
    sha256 cellar: :any,                 sonoma:         "7be9eaf34d9ca87b2983b8357b9409a8ac446e51121d95e5d59af0310c4b52c2"
    sha256 cellar: :any,                 ventura:        "218ca245cc6fe667194dafab7b7d525b6d4ee30ab3e01da3f7dc0e7ac394124c"
    sha256 cellar: :any,                 monterey:       "6842377344e46d79fcfed403bfa4c91bf23c8908610d50e842c0134eb9d2de11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "241041172aa30880d100361dca278da9b0d59364751e4f45e633414654dd63fe"
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
