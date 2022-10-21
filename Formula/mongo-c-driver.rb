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
    sha256 cellar: :any,                 arm64_monterey: "8989617e5bcb60a51fee7918af052e59d6419d9c84f79003053152f610bb7603"
    sha256 cellar: :any,                 arm64_big_sur:  "2566f105a6cdd5d34af7fc5a8a719a77f0b5e3dc8ddb61d9519277e8bb9f4975"
    sha256 cellar: :any,                 monterey:       "3b6cbfbc7bafd609e9472a3f8ecb194ccdd3ccf14b9ff194f0d22f74478cfdcc"
    sha256 cellar: :any,                 big_sur:        "a17d50cc7ae9217acf771420b8a81ec747af87dfb632a42ef6880abed8e30fb3"
    sha256 cellar: :any,                 catalina:       "01a0f270a7701a8706337520c74de77bac2c0b88d044a80a8aa1d4def8b165d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "690d394b4b8ac71acc05cf8a49bd8035123259abe5a719c8091c519f3f7cb4cf"
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
