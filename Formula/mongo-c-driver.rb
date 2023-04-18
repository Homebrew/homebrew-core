class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.23.3/mongo-c-driver-1.23.3.tar.gz"
  sha256 "c8f951d4f965d455f37ae2e10b72914736fc0f25c4ffc14afc3cbadd1a574ef6"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "db5c88be09593f619a09a71bb05b66591550e17e56ac508d201273eef68a90f3"
    sha256 cellar: :any,                 arm64_monterey: "e0d08302ecd44e788b8f6c42e86d5d839c7e9eaf90c99913070b54779b086de0"
    sha256 cellar: :any,                 arm64_big_sur:  "c0b9319bbf631328e91a56c928ee16cd28b6fd5ac2541053a27ef3779e1755b1"
    sha256 cellar: :any,                 ventura:        "13d2e81abbf99f497bbb1b9482199ffffd308737ae04fee444b9f4c076d00658"
    sha256 cellar: :any,                 monterey:       "3dd1c5a56d7bf9aed39ed5a40b73d38eef73065953c8d1c671c883110bad4cfd"
    sha256 cellar: :any,                 big_sur:        "84add4ff6086c17d894b048936145f28073f107fb9a34027221e50947e618b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8151277ce905fcf9863b5421fa985d9b3ec0b7dccb8db80a07f3713a1a224798"
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
