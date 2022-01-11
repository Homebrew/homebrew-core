class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.20.1/mongo-c-driver-1.20.1.tar.gz"
  sha256 "c2e17ed23dc6aae72c8da8a81ad34957c35c270f7b56349c107865afeaf10d65"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ccbbe0de41fe056ab76169997f1bdafd16986f592c3cb0c766c2dc8fa983b8a6"
    sha256 cellar: :any,                 arm64_big_sur:  "f5922cd476d1649ec53df8d15b7b7ca1b3fedf89f5117ba3124be8f9278806fc"
    sha256 cellar: :any,                 monterey:       "dc38ba1f47a6553d1faa569137634a52c4e59b9e3c4f9868046fd2c867d2245f"
    sha256 cellar: :any,                 big_sur:        "e75ac0832b93a715d3cd90bdf1d8d8b7f59fdd08d8b35efab225fff1734be6a5"
    sha256 cellar: :any,                 catalina:       "aaf2c68ecfefdce66a12199e72d095cd096b2ba9f541dcf81e3c6e8aad9940f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b692c90cc74eb8dda155b114d161dec53d99bbd1075140af3ab16de82816ee6"
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
