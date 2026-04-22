class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.2.0/mongo-cxx-driver-r4.2.0.tar.gz"
  sha256 "391c321891d512543e35f2a1889972384df52d4e030fc3a6a6751bd6bf75bc92"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d537b73fa8e6f4970c72da1afa8661de14f3bc7d14ae390c13580fa6a1989b46"
    sha256 cellar: :any,                 arm64_sequoia: "e537e9f9cdbb6b9c1fd36a4f5352f556bdd1b3c5b8b90faaaf262d750d07b373"
    sha256 cellar: :any,                 arm64_sonoma:  "df9979dabdf6bd22ed901ad996b1cced1afb32b64ad5dd6ca3e9ad7fab91e6a1"
    sha256 cellar: :any,                 sonoma:        "29ebee2eab8f7d88e701266c6ef5f4233f18f818bf5f9ac3006ca03a25198aa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba252c79ebf2ef4e4edc556719cbf560b09b0150d1a6af7d0f4518780c02fbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ff04c45cbf2f8ca387bbfee2507f96760a188c8c92116c74855b2bf0379d12"
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
