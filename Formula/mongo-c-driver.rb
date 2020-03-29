class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.16.2/mongo-c-driver-1.16.2.tar.gz"
  sha256 "0a722180e5b5c86c415b9256d753b2d5552901dc5d95c9f022072c3cd336887e"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    sha256 "bb6ab84a6dc183139d0f3fd2f8680094812fb9465858c4ddfd6a0479e9f6453f" => :catalina
    sha256 "9fb343166799b012645fa0f031f81ec068ab5f196b60ddab201b0bb2446fe218" => :mojave
    sha256 "2030cb7799a73518a952ee5b59348cbd90e52c56f41af0eb427a9edf3392da0e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_VERSION=1.17.0-pre" if build.head?
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
