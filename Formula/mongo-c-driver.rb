class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.20.0/mongo-c-driver-1.20.0.tar.gz"
  sha256 "a97242866212bdcf9dfb8030b31a32eef9ff83082b34e1027339c805a3c50b0d"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "374efdef4f8445ef889e34b59e36b9aa36f2d1cf278e638ef47a7159ab5e5374"
    sha256 cellar: :any,                 arm64_big_sur:  "0de2bee416e8b6ba51a400e4e754d87c908fb9a25685eb30fe1faa7ac5e01d39"
    sha256 cellar: :any,                 monterey:       "7bb3e1580f3897a87ed82ecb8906da04847bdbbac71973b9302be36add965ac4"
    sha256 cellar: :any,                 big_sur:        "de451485bdcf498cb967e0d68b2254526f36a92514e59501af8a0c4e7eef914e"
    sha256 cellar: :any,                 catalina:       "84834568b98294d2764d1256ae549e1b02789db8bb09eb2ed85104505f26103a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1514f36700ab9f60f773ca390e5841499cc49277ef500579012d9d3478f456f3"
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
