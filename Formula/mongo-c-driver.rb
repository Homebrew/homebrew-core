class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.23.4/mongo-c-driver-1.23.4.tar.gz"
  sha256 "209406c91fcf7c63aa633179a0a6b1b36ba237fb77e0470fd81f7299a408e334"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d96ffea84f5a3d3cd7b15d6699dd53ab35bc4b4ee2bb127390d047b72d84fa31"
    sha256 cellar: :any,                 arm64_monterey: "6db2117453abcdc2b29a8615fe9b3d810423a944ad02f7c77f02dc7dd36d9c7d"
    sha256 cellar: :any,                 arm64_big_sur:  "d63c1dfa1559365776d6cc308d561bc10ae6957c63755cae3f8d11fab8c77e34"
    sha256 cellar: :any,                 ventura:        "f08c67ec235cfc6198c69f77ab1ba5c884e7f54d2c6385263ac35ad67d5172e2"
    sha256 cellar: :any,                 monterey:       "f35982c6a57fc19031c86667c40480ac3a1dd8476327cf635babccc26a0050b1"
    sha256 cellar: :any,                 big_sur:        "5379136959de260dede8568f51785af9c2765f11ef44fe596509ae596c413d6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce36cff5d88b819597ca20c8b777dcb6d3d7069b3a070cd1a29b4cb6c5ec41d"
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
