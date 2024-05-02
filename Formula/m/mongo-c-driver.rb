class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.27.0.tar.gz"
  sha256 "9ebb372887d90ed41865d0cf5c266095368b92c8ec0eadac0dd40e7909ab71e0"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f56498f2603c6828cfd88a1f63c0d208016f143b140305308c0a4f716feea55f"
    sha256 cellar: :any,                 arm64_ventura:  "e32087a934a965106561db542d02ecf60c4232d7b071b7b4e8edabbdee678e7b"
    sha256 cellar: :any,                 arm64_monterey: "86c99765799ac63df31429744c595c2fde51da3601029a9f3588b9a6108b9aa9"
    sha256 cellar: :any,                 sonoma:         "7a9f9443e2280f75d3782d421e87f0af6adb8016a4ce00224965c9517860c525"
    sha256 cellar: :any,                 ventura:        "5fdccb00503f51dbf3b9ec9a7e146fbfe23aed22077f10d96e8c138b2ac4dd76"
    sha256 cellar: :any,                 monterey:       "f0d5a420341e407497af7a4c7647c5793e1ea402ee4bf242942ec1ac46597867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd07be14774a697a25099c880fba5873bdc6475a35847c773c25586725a40c0a"
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
