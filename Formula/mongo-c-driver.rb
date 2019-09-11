class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.15.1/mongo-c-driver-1.15.1.tar.gz"
  sha256 "4ee47c146ff0059d15ab547a0c2a87f7113f063e1c625e51f8c5174853b07765"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    sha256 "8df25e1bb5101bb1fd920e48ccc0ddf09b92bd89619a55189c9ea1af5b2167da" => :mojave
    sha256 "e290daad2e58ac398b47227c9b3a7484bf2b73341cd9e2bc2991b554822f3218" => :high_sierra
    sha256 "6544daf5b18f3004d7d0a9dfbfe9594dafa37e15b57f55e3d8b99c134f25d9ef" => :sierra
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
