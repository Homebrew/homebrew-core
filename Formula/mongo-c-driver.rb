class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.19.2/mongo-c-driver-1.19.2.tar.gz"
  sha256 "b6feb4fd65423140cdee02df392cd9db2bb459731e992a5385afa554a7515762"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "248678dc27ca4ce53cd4a2373fb0d0dcd02cd2d9caa36a6d0a91ed9d1160d0cc"
    sha256 cellar: :any,                 arm64_big_sur:  "56e8d90faf11ed935ee43b0900bf1df6fc2307aabb4a6688fe6d6e55d334a5ea"
    sha256 cellar: :any,                 monterey:       "8abf2f15cda906faf32f8a1142a9655619000039ef648c901bcf1e83f0abb2f2"
    sha256 cellar: :any,                 big_sur:        "8bf977fb5a1965368179642184981bd0d501560699795659cbe509257058f755"
    sha256 cellar: :any,                 catalina:       "f752065ec9fd540441383301f006b00fe166f0d23f5ffdcba4930b985b816523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9576f248394480574314ad3a171a149923349c35c3474bc72dc73a716630c71e"
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
