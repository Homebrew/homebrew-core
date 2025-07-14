class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.1.1/mongo-cxx-driver-r4.1.1.tar.gz"
  sha256 "19dff3cf834a3e09229260f22a0325820a7e30c78b294db91794dd934776b33a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be7e8150882b1b882968af2e8c7d22b0bc5936f5395ef9a5f4ad576f70d7d71d"
    sha256 cellar: :any,                 arm64_sonoma:  "c5105dc245cf7b43c2e40bbc8870320cc30305b3408e7f30b3db20919917b647"
    sha256 cellar: :any,                 arm64_ventura: "17f855e067527a27e797c831abbf1cb39dbce8ff26c2dd59995b62fc26134ffe"
    sha256 cellar: :any,                 sonoma:        "7e723bf5a2dd50a6c8cfc33cee28f3ca69221c7d0e40c1c1891f513a66d59ae8"
    sha256 cellar: :any,                 ventura:       "2e6bc9f5c7e8a978c132cc1c23adfd446a0945b187be690f65a2f33d66a6cffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b218e683cfc30828cc3b3329766d7feb0bd6fbb7d5ff23d542dd0d025b7ade7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395b19a27bc22429bcd7b9fd6f63e308a8c5d8463259a976e21a34a7d1fdb7f6"
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
