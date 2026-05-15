class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.3.0.tar.gz"
  sha256 "0edd0e143af77861309d59c5c029d2408df7348c429c5e1f483c7ba449cb35ce"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "336926859b333b66f2d74164b652b5a0c0a3e1b99524e0e29087db3ce8f69537"
    sha256 cellar: :any,                 arm64_sequoia: "ebb36242b858213ae11773aacc11ec7c2df90da4a06d2f5a851dbf5eaa8999fa"
    sha256 cellar: :any,                 arm64_sonoma:  "cc736db383f037928e0635bd19b196e68a2ec401b1ddf01a1db0275dfb6906f9"
    sha256 cellar: :any,                 sonoma:        "5681798f8425885c4eb5cb5d751887b5bd68465b0ee12735271ec101ba659712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9499499331e8470642bdc2fe7d32c6ed3ae663fc4ea80dac1504263d2da79a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace76b739e8a16294c95c3982b57d581c8154d3df299b445a4edb35373126d17"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    File.write "VERSION_CURRENT", version.to_s if build.stable?
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
