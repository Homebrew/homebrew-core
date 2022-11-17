class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.23.1/mongo-c-driver-1.23.1.tar.gz"
  sha256 "e1e4f59713b2e48dba1ed962bc0e52b00479b009a9ec4e5fbece61bda76a42df"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d482e5d152b02642206a720ee1e41692a96fa2a4c2e2d8abcc75e23832418dea"
    sha256 cellar: :any,                 arm64_monterey: "6b6b0f30c0ce890524dc32bd9a85c7d1a4b8c56f4bc3fdcc9c2a901c66c92683"
    sha256 cellar: :any,                 arm64_big_sur:  "ede7a8590fc48119ecb83aa51a7aed6f780872914e95159a20a04f160df60a35"
    sha256 cellar: :any,                 ventura:        "d6e521550dbccada9e93e5e9b3ecb3b886072aa8d23a005ce33db4968904fe10"
    sha256 cellar: :any,                 monterey:       "c0971506ffb902b1fb1099a0ed00b4d75f67df0c7333115c69295373bddcc073"
    sha256 cellar: :any,                 big_sur:        "e97aa453a73f130a7eb8775e5bef8180ab5b9a46b794c47b1e8d440ba92d76e8"
    sha256 cellar: :any,                 catalina:       "ea52a6972a2fb4004308f9a402c5336fb6fd581fb9c07eb9d6b2a2a8403dcb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "659e5cb00ad832dac422564d64257564383c32c40a8346c980170d0f8cd75a19"
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
