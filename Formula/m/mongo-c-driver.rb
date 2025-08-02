class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.1.0.tar.gz"
  sha256 "dfa8db7750a7b4a49c840c1319dbdf7f3b7b4583003139927de37e71b5ae043a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4cb73190a3b3f8684088ff8cef2b2ea98b6077c3155b3e2211d1a5aa73b6282"
    sha256 cellar: :any,                 arm64_sonoma:  "3383b773436e5bba75a95a4aa5318b2321ed7b28f9ed93851a2f67790445ac23"
    sha256 cellar: :any,                 arm64_ventura: "bdfd4ba3a6317f922cf0e943866e026e1e4b48bf52e4827d0c51c44bad8c6a5e"
    sha256 cellar: :any,                 sonoma:        "e1963a01701302b7568252a9466e0653b00a25fdc754cd09b745e72438144b73"
    sha256 cellar: :any,                 ventura:       "321346e0443c9a99a540dd6968dcb7228df7f72f44dcb27bb21ceae9f2842986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3585a69ffc764531297343c0968d87e66802139752157dd5c6a0ec51c1a82395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb59a407bec3d47fa5dd00b2c9009270c5a0ed7df9da067102802cef31955008"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
