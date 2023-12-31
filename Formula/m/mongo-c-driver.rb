class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.25.3.tar.gz"
  sha256 "d7cdedc5164b7b8ca39bb45bee789da44097052c882fa84996e4d90eec6fe8d3"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b62e15ea7e63c7f30ae46078bb603901ec6023bf3b5bb1dc7d48124d221a679f"
    sha256 cellar: :any,                 arm64_ventura:  "521cb4e8af4718d02a6d8c5f17592657a482b2b639f8c41a3f9d763924a0a12f"
    sha256 cellar: :any,                 arm64_monterey: "94bd017e3623e21be55e6e2fd7bff4c332a98d673918c87837bdcc2a07debd10"
    sha256 cellar: :any,                 sonoma:         "5cec5679a06bb75ca2f0457ee887cbefb15f027d27a3e2a03bcd90f25ada755a"
    sha256 cellar: :any,                 ventura:        "7774b6af77fede0df72b8c230afc25c9e079c823d69b93df1e792bec602ad206"
    sha256 cellar: :any,                 monterey:       "d5247109deee207d0e0eca685e4c2769a45b3a85512cae0411c1aacdd49acd41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2614463a4603ea6c86fc63558251eb90f5dd48f6680511280030cb5b566f7124"
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
