class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.26.1.tar.gz"
  sha256 "718922183339db70079d4b56d37789a9e4aa0a62bb4d5eac55e3013da18e6d39"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72647f4157506c042ecbd2bd6a03137cb58da2c04132da60f5310f147e5946e4"
    sha256 cellar: :any,                 arm64_ventura:  "b89bcc34e2e94b99014ebb49a2bac8202cf3efd3ff75013c8325cb4a161e9db1"
    sha256 cellar: :any,                 arm64_monterey: "31ff870e7052653011618d79038f640b3cffbc815f543fc92d09455e209b77db"
    sha256 cellar: :any,                 sonoma:         "def7f55215e4251ebc50494dbdaabbc92129c9eb3fe46cb65bc715438c800380"
    sha256 cellar: :any,                 ventura:        "062cd65172ab1cd3469d1ce9e210e1e459f1376fd078ae11fda49a6c88b3d806"
    sha256 cellar: :any,                 monterey:       "5cafb5c7a0bc4480f3437128fdaba1e7648e6ddd16a68f08e349bb06c2ca7374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c390d37faefdbc81eeeb30039b718283b7d938133128f783c2b26fc97429ae7a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    File.write "VERSION_CURRENT", version.to_s unless build.head?
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
