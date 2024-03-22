class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.26.1.tar.gz"
  sha256 "718922183339db70079d4b56d37789a9e4aa0a62bb4d5eac55e3013da18e6d39"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "924e13178463e0274f00ae43f27d7c01deeedfdd282644bb4b66524ff6269a1c"
    sha256 cellar: :any,                 arm64_ventura:  "b4861b7fc6a822b721e90953b3b4154f9e36982f8c028f4648daba77668c3f67"
    sha256 cellar: :any,                 arm64_monterey: "adbd9f257746fc848c265ef2099d35f1107991092c0c5acd72e3bb00e7e0beb4"
    sha256 cellar: :any,                 sonoma:         "e01a3358b145289f6ea7e2e6da012ce85f3db1fb69fc22a659484aa0fcba97de"
    sha256 cellar: :any,                 ventura:        "ee0fd47fab5380fccc3c880533c9b6cefc69373536dfbe4db0d333ca0110c9da"
    sha256 cellar: :any,                 monterey:       "7210b64f7713265d13feb96ce3beb97e28b617ae58c71c5d7ceb99f7f3c4efc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1dd891fd43f5d60a36954ced21161b1fb9e526607a678d5cac72904b34d676b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    File.write "VERSION_CURRENT", version.to_s unless build.head?
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc
    system "cmake", ".", *cmake_args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
