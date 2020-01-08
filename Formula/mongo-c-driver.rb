class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.15.3/mongo-c-driver-1.15.3.tar.gz"
  sha256 "a09b871339ea15508baedd7777d7eaec13af962b4351e2fb2e19278d7313e049"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    sha256 "2f94707260a5fea924d31ace5a59488d12416b3af2210b70dee6bc348639703d" => :catalina
    sha256 "81800eac9a888895667a8f4e69abbc8015808f89d6868e88350d119bf5eaa017" => :mojave
    sha256 "dc5db3fe408d3b70d5cf0bf74e3c67afb0fa861e13ccd084515ddfed15766abc" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    cmake_args = std_cmake_args
    if build.head?
      cmake_args << "-DBUILD_VERSION=1.16.0-pre"
    end
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
