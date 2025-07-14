class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.0.2.tar.gz"
  sha256 "869395225b184ea9a527b33623b2c222d49230b5741071e7227fa7d7bbefdacf"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f0e8c5ee2187489716d8d710a4cfc8935b1f7040d3045b161176c43b3a079c3"
    sha256 cellar: :any,                 arm64_sonoma:  "c9562ff8f767b3499331fdb1dad2585a22075d8e8f1ffbc9d3988a099bd35ae5"
    sha256 cellar: :any,                 arm64_ventura: "758f3cd09b9bbcbf9e3f87f9496f4b110eeca85103064bf85b2b94771f3cb993"
    sha256 cellar: :any,                 sonoma:        "ac9b744d03e5aed7f84c9d41b84a6382c399c9a2c360243f9afb245df4e02e24"
    sha256 cellar: :any,                 ventura:       "80deb31d572934f0932cb576f06dde72e958e7966f7dcb6cc1cc2d7febbf0fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b86bfd6f453f53d6ab712b88e54045bf327aad51437f153ecf272b25c392836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "048850406e870c9e7054784be3bff048d07237e7629d011820d424c4e07ca387"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    File.write "VERSION_CURRENT", version.to_s unless build.head?
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/bson-#{version.major_minor_patch}", "-L#{lib}", "-lbson2"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/mongoc-#{version.major_minor_patch}", "-I#{include}/bson-#{version.major_minor_patch}",
      "-L#{lib}", "-lmongoc2", "-lbson2"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
