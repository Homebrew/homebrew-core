class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.10.1/mongo-c-driver-1.10.1.tar.gz"
  sha256 "630e83bfc97114a9936f0b6871bfd593b538839caf1d3f93c8038148d1b9a4d6"

  bottle do
    cellar :any
    sha256 "e757c76b5898031b331888c420a2bbad1a31da383af2a6eb0de4d2e97e20b780" => :high_sierra
    sha256 "50e03b60589a0ce89a7431640b3d0f1e0a28ebb4043ca46d2fc81f0720a2cf1a" => :sierra
    sha256 "c0c0a96e74e6d5f67e8cbc626918bf6805dcdaf8f9ace5cb3b6b9d6ddb81cf68" => :el_capitan
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
