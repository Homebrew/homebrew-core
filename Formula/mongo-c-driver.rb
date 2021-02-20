class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.17.4/mongo-c-driver-1.17.4.tar.gz"
  sha256 "9ec8fe7fb54d636886fa823460658ccf660e3d82520d10810fb7c9d302ac974f"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    sha256 arm64_big_sur: "45c1f1d31d63c3ea4bee65f5c6a56d871fef8c91eac8d2018e49226175f5bad0"
    sha256 big_sur:       "3ac6fad5ce56f4052ec8e0817aadefdd69caba8fb53479ca42227e04b681ee3b"
    sha256 catalina:      "47387c38d9b91dfb46d5257f64f8292f53acbb6f5fa17ca34ad3a44d236f1ae3"
    sha256 mojave:        "c3328d3c7dcae9408a29f9b4976d3cdeae255ce8ddfdd43df711706c53c0d6d0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_VERSION=1.18.0-pre" if build.head?
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{lib}"
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
