class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.15.3/mongo-c-driver-1.15.3.tar.gz"
  sha256 "a09b871339ea15508baedd7777d7eaec13af962b4351e2fb2e19278d7313e049"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fbb0256760644f90124feec011db8a441fb6708233c599b16f1f583911245835" => :catalina
    sha256 "f128cc30b15aad0b2cb4957b2dc86da627e56cb8f18fcdba76a6e422ecb6b7d4" => :mojave
    sha256 "641f4c7b285ee136b73c0037a4ed49428c92b657253ca357363379c29c372304" => :high_sierra
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
