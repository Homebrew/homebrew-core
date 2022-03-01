class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.21.1/mongo-c-driver-1.21.1.tar.gz"
  sha256 "2dd10399a31108116236ada68ae6d3f4b1bf78c03b43b1a33933d42aa0e62ed4"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "df18eac096f97822aac23dcbfdf67e76a14757fe669e6d198143629a61205d3d"
    sha256 cellar: :any,                 arm64_big_sur:  "026598476263ddb6113c40e89f2553d069b680816e41f505b72e0a12d90b9c85"
    sha256 cellar: :any,                 monterey:       "be357073e0a040afe1a9714d76ebf3f694d85b0de089e8261c4629e297d0ab55"
    sha256 cellar: :any,                 big_sur:        "6a006bed68cb688b685c6300170cacc73cebaee0db16cdc2653521b5fb2d1d57"
    sha256 cellar: :any,                 catalina:       "71d7574c0c0f690fcf075fcf675582dc02473d46132a27a5c015e332d1598d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9565b4356652ea716faa669c44d6c011e953c386c126e0016483bec8d9fef65a"
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
