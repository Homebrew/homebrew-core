class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.24.4/mongo-c-driver-1.24.4.tar.gz"
  sha256 "2f4a3e8943bfe3b8672c2053f88cf74acc8494dc98a45445f727901eee141544"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "17ebfdd8ea69ef2171b87473676c80fe0ed519ab4216f2990b42778020f5299f"
    sha256 cellar: :any,                 arm64_ventura:  "c2fd7644c918747a0521a68fad086908c91deb8506a55dd3a2c142168fa8f07e"
    sha256 cellar: :any,                 arm64_monterey: "8cbda3bb22b64e1ea501ac9e091baaa16b5bf0ae9950503bbdfd3e66078cfe4a"
    sha256 cellar: :any,                 arm64_big_sur:  "194cebdfad6f7b4ea9e04f21c241a24ab006ca7ded6ed1095b8dd6b266b0a1e8"
    sha256 cellar: :any,                 sonoma:         "82077b479c72e74d3b30ef9ddad8712dc920416262e4d6594f73579c8652803c"
    sha256 cellar: :any,                 ventura:        "2051bfc82101e2fcb48c02d16da1e08363dd5bcabfc3e0edd32a58c2129c5fe1"
    sha256 cellar: :any,                 monterey:       "7f757e1bf49f30588f890b66c25fb44e6ff9190941948856c5049f230bed8694"
    sha256 cellar: :any,                 big_sur:        "0f082f0266790dac2bf302f6100f6d4e465c87ecd65140d44f06c266c0775a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb34a17f77c5ff930a56e5a7421bc31f145394a8e09d508fa7c315311ae5a11"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
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
