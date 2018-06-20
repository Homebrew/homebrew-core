class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.10.3/mongo-c-driver-1.10.3.tar.gz"
  sha256 "0b6d5888a3a87b75d2aeabfb6ae7ac09196d06debf7f2cfc2781807a85c2aaa8"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    sha256 "9744cf2e57973204ff67057bad16ccc573b817a7845bf208501e04867ffd731c" => :high_sierra
    sha256 "a95ad8f8c4cba2c8ab2bc6fc59cd1565dc865258273848d21f0754c983f319a4" => :sierra
    sha256 "79018a1304e160cc449e96aec85a464e637a12dbd5697027b525766ac7876e05" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", ".", *std_cmake_args
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
