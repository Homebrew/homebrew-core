class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.21.1/mongo-c-driver-1.21.1.tar.gz"
  sha256 "2dd10399a31108116236ada68ae6d3f4b1bf78c03b43b1a33933d42aa0e62ed4"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7dac05a0ed204114472e79dbcc89be5958bba10994fbd12f1079c8ec46f8a9fc"
    sha256 cellar: :any,                 arm64_big_sur:  "511dcf7efa510f5f9a5951c9fe3b7d8726e5b7f5a7bae09fa975c5f676505fb0"
    sha256 cellar: :any,                 monterey:       "6b549206267ae2e93639709d3c4d0e761c5fa4ca52a27d756d4fc2fac4971051"
    sha256 cellar: :any,                 big_sur:        "90f2abe5f4552ef98ecd4990f85d21f8b3ac9ec37da3ff0cadfe7b675e9f3bf6"
    sha256 cellar: :any,                 catalina:       "f75eefd5ae2bfd7e1224f493e2de2d3b0962146a334af9168b66ef0d124cb086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9baad85eab3687cdce14d244cba76f23a3aeda54880d94a6987fb12e91546255"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_VERSION=1.18.0-pre" if build.head?
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
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
