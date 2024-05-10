class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.27.1.tar.gz"
  sha256 "cc97407b16da54ba9b27029237b9a7a13651ada04da15e3b5dcd8fee8db20eed"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b80226a3d136c89c8afaa7f5ec1f943f3bb99c89d4cb27ffe6fb02097f262fd2"
    sha256 cellar: :any,                 arm64_ventura:  "856d33b5fd322e9ece76110cc0420c53aee66d558a5217e70b58b43595346927"
    sha256 cellar: :any,                 arm64_monterey: "82cade57bb3be13008fc5ffe7464ad749791f8a330679871c1be9324317c031b"
    sha256 cellar: :any,                 sonoma:         "6fe70a3c089310d763a1cf49f7b40d7b7e1d6ab7d99310ea366fa9ffb6789b12"
    sha256 cellar: :any,                 ventura:        "9b88672c320341def65acd4cb810b9a43fdd940adb99e35e4c24dbd2cefdb5dc"
    sha256 cellar: :any,                 monterey:       "de8f1136ed14af3a88233806499d3efa42d0a46315540326de4ca1aa3291dd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a719eb5a3ecbc445287dd5b63c4eb4b1aafb11c2e182752125f21318b97e83f"
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
