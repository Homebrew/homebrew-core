class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.27.5.tar.gz"
  sha256 "b90dab0856448c5919c1e04fe8d5a4d80d57779ccf8cf08e3981314a5961973d"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7816f9ec4b831b462c9cc3f46878d4bb7d30a69a6416991a0ad2cb4b7366d431"
    sha256 cellar: :any,                 arm64_ventura:  "40a509c467919e46260c05566833b82d732b0dd765476280a0cd2116b37a9ba1"
    sha256 cellar: :any,                 arm64_monterey: "fe4591fa258895214f970e009e599a4d31124b592892c930a301c9049db9cbeb"
    sha256 cellar: :any,                 sonoma:         "6abd1326907c709255b855ab32b1fc3f139e14ec71d339382c1eea3f80cd4828"
    sha256 cellar: :any,                 ventura:        "39c77eab74a6e5f9975a94c028bc723becc7108ae5ffd14432a870f2c99d199a"
    sha256 cellar: :any,                 monterey:       "15493579f0a6927fcb8ef15d586335e8fb3f27374592494ec6ec3d8ddec1a455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de8b97cd5d1d4fbffe7cbe88c4b67e54d1d44df80b57f2fb7eda1f3bdfe2574e"
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
