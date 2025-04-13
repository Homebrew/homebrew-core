class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.2.tar.gz"
  sha256 "e3b2d7c18f27b868b99c0ab2e9c811852fa4d86fe2d1d55a53f42d51859dd99d"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27fb9714cd35894ea2ff3ba8a8f15404e7e8891828017af6de24bd42b07e2800"
    sha256 cellar: :any,                 arm64_sonoma:  "32e547870031851b3593b3ae1b47448cd0f16716104565ec0a47e61396ef4e39"
    sha256 cellar: :any,                 arm64_ventura: "3e3797c1b3afb92ac3735f24fefd37538bc62e4c2d271582d371203afee4adad"
    sha256 cellar: :any,                 sonoma:        "3ffda9abb00eaf6679997f0f3f9a132e94d31ceae9795538ae717ba4cf6572f8"
    sha256 cellar: :any,                 ventura:       "48296c8aa08d70a3ea1c68b0696a8ee41d6cf4e6cbe96699a22f2e5860768327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bc0b2d8fe455186465e54c541572da488e67a4c86715e540fe0443646067e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e1ebf7816f3553b3a0bd82b2a078177f1ddef47020adea67144781a459e0b2"
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
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
