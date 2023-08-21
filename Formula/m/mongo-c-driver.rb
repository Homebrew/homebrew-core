class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.24.3/mongo-c-driver-1.24.3.tar.gz"
  sha256 "cc0ad1006447ded21bbefecf57d6fef61afe6f0d56a4e28da73805d50fdb81b5"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e902dd1f043d95001dcad6ab486478a1b240d93fc65780c7b7ad01f0e50db816"
    sha256 cellar: :any,                 arm64_monterey: "aae53ae5ea1ea475f374ee9257bb5c36445c66cc019c6d0fb51a4d0696c5b6cf"
    sha256 cellar: :any,                 arm64_big_sur:  "42364185101510788e67ff70582ce9f48a8bda606e29d88107a7800a4e7f6d56"
    sha256 cellar: :any,                 ventura:        "77b920816c21595c4812bb5c0ce3125e1a467950c50b34e2285624b6bee6ad16"
    sha256 cellar: :any,                 monterey:       "9ad19be320fd8b4ed20310c20715974bb2608d966dc1203458776e24e456c2a2"
    sha256 cellar: :any,                 big_sur:        "72e9184f26578e9100c4ea09a1e4c4e7777921e21ba140794b9bae2c3449116a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee79fc1d1aed4c3e61974b231f5bf21a88681ac4badc0a64253c1e3a76d97df9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
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
