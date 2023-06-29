class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.24.1/mongo-c-driver-1.24.1.tar.gz"
  sha256 "f9bdf71f24c6621c12535bad07f4654a218d84f16b85a68aca3abf6cd36d1859"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bf2cc3500de94725a7a64341f8e0950aa6324271bf51c4036ec6c763efea506"
    sha256 cellar: :any,                 arm64_monterey: "205332b62f77f04d9a32b2a57fa19d5fdce4c6db3ba2ac6ad3d964c2ba3b8a5b"
    sha256 cellar: :any,                 arm64_big_sur:  "f74b75e1bbb7bee0415e975f7aa7846d32d9a01b8f1b48f7c8538f0d61cd471b"
    sha256 cellar: :any,                 ventura:        "730c4f89d68846eb63b2ac6fef3ff1798f8c51b43b4749fa995718e384cd92f0"
    sha256 cellar: :any,                 monterey:       "7ec25a7b3ff54650ec8cd42de104d1afa0a0862c9180f47718fa271b6a50995b"
    sha256 cellar: :any,                 big_sur:        "b87ad41a8b7462f83249792c8146f57d59dc11d49652a94810779e9fc91a8110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ccaca27af05b3c39620de63ca33285eba01bc66806c25a96663f7e026ce3b12"
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
