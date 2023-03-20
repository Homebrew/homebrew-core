class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.23.2/mongo-c-driver-1.23.2.tar.gz"
  sha256 "123c358827eea07cd76a31c40281bb1c81b6744f6587c96d0cf217be8b1234e3"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "753bbc9002137403b276d5fd8cbb89281c979a323a002e47fa3f9a5ad3621af0"
    sha256 cellar: :any,                 arm64_monterey: "d6498c1519bd67a663f5cedffc2dfcaba0c0fa5c709ac4191088bde060d2c7ed"
    sha256 cellar: :any,                 arm64_big_sur:  "95d55758ae6d5d5b849047af0d47b0b5ffe0c90edbfc43b42389e949761a84c6"
    sha256 cellar: :any,                 ventura:        "aa40afaaa9b5d5741f81dbf40d202216cfd65683eddcee6c6e770faac7618b1e"
    sha256 cellar: :any,                 monterey:       "ae3c5ac06d01c917a78f85e8009f0f53a44344747fb80b1108dfa4215415ecb8"
    sha256 cellar: :any,                 big_sur:        "4c152680d7d60b9abc35f8e54066100d9a6e697355851a3c8b1018981bd6d4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f78148571b7e0a1540d145fb662d8eddd81296abbbdcce9cde64a6c602a404"
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
    cmake_args << "-DMONGOC_TEST_USE_CRYPT_SHARED=FALSE"
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
