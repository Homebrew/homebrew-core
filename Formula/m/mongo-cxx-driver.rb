class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.4.0/mongo-cxx-driver-r4.4.0.tar.gz"
  sha256 "affa1163821cde865be2ba46e5d8348d87d4b47eb181b021455a1b4b7b7261f6"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4f1cc2a5e90645a0e6a0fb06922c755309d4a2511337a6df08540f9638ddf11f"
    sha256 cellar: :any, arm64_sequoia: "f539b473bc7038ea1fc35f3ce160f428abe5dc4bc78726e160f7920cfaa365ba"
    sha256 cellar: :any, arm64_sonoma:  "14dc160d36fb3279c8583e7df274623e10a08d3162fcc006f767cd8c0fa6aba8"
    sha256 cellar: :any, sonoma:        "cac961941f771a4bfb1547db6661db7fd080112e8583aa165a23abf3723369a1"
    sha256 cellar: :any, arm64_linux:   "e3bbdf084dde3a53513ea1014decf8ae3a04d7eb65208788a9a4545167abb7f7"
    sha256 cellar: :any, x86_64_linux:  "ff652e971d719234122f8ece6d15b95e65c1388d0b302491225ad9b351d16c01"
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
