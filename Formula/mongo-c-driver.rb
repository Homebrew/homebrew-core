class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.23.5/mongo-c-driver-1.23.5.tar.gz"
  sha256 "260dc2207881ccbe7b79b1fa6b3ba84ab9be94eb93d4beefbbe8a6cb562947ed"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bde67ce7cfe1a64da74b03e2ab9611ac3dc84419f2731e443b76f33623458834"
    sha256 cellar: :any,                 arm64_monterey: "270d76921e28ddb32c0c35548ab5b951b75138f8c1bc4fe461675287a72ea549"
    sha256 cellar: :any,                 arm64_big_sur:  "380677d64f7a0f345a679da315dc873c3bbf50c4a3391e1a0013ce5321aa544e"
    sha256 cellar: :any,                 ventura:        "0f9be49adc69281487c87ed8120425c026c08e3f87f4d046249587b569e60643"
    sha256 cellar: :any,                 monterey:       "b16bdcd2855a987e4aea7e9f1f03433f3bf31df9264f5387a2b3180dc2f31ae3"
    sha256 cellar: :any,                 big_sur:        "546f25ddd4c510fe678c3fa80e6418d0f6a9573c1b983e1d621e2c2b9a89282e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e2e920826bb25d65aa88221c3aa8dad738cecc46ca7f109e43b4270165ea0d"
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
