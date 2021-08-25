class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.19.0/mongo-c-driver-1.19.0.tar.gz"
  sha256 "23c365d319f0a53af81dd7d56f35e90c24ec32a21823c2f36c5d8c2d1edcdd6f"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fb4cbfa74810524b991c1271e82c1ecf7bea06236ef4b8780ca2b4a0e0354546"
    sha256 cellar: :any,                 big_sur:       "443fb61faf8b00fb7c9bb1980c020aecdb78b773ad9a20d94c50a2227d881840"
    sha256 cellar: :any,                 catalina:      "55361a759155c4920aeaab5029fca739f4b041745f3a4606dbd06a46c0ef2af8"
    sha256 cellar: :any,                 mojave:        "5b0fea8d91eaaa6dbd1fcd007197d55b8824228501ee4b69d42f7a6bc6c1508c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26271cdc780a6a39ab73c08c9f8c44232700ac1f0d55f7e4341c2506a7e28789"
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
