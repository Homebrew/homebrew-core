class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.21.2/mongo-c-driver-1.21.2.tar.gz"
  sha256 "f9ba821fc646be893e9b9d4adfe7bded80f348b3c95b1361718caa7d965fe6f9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7b4a733ce1c1153ff762b24799b8c631426f36937c1a1f575b7f746ef8eaa18e"
    sha256 cellar: :any,                 arm64_big_sur:  "dcc9df55d3dce1dd3d120575ba21af6d0a8898919da9026d08a8636d862ee20b"
    sha256 cellar: :any,                 monterey:       "6a525de56cabf4655ea68411e63ecfd6d6effe05979bfc7080c4a0b6b9d663ef"
    sha256 cellar: :any,                 big_sur:        "004bdafe83f7fc99d2cb829613ad6636b5098f7fdebbd20391b92390531d0702"
    sha256 cellar: :any,                 catalina:       "48303bcd6f56263322b9b859a75de418b023676136923a57b72fda4f4ae14a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86fb650221223e343599ca92ec1617b07d8b59b638fc922bb3e20939c875b4db"
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
