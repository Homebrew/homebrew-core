class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.25.0.tar.gz"
  sha256 "c61e1d20cc46744429ad11679f398a3907f402bbe82a12689e5aea6de72f58ee"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c15a7926ebec2f94ecd68447c391e8587f7c3fd9a3f6a5c0b2873415e779b6e"
    sha256 cellar: :any,                 arm64_ventura:  "7876e9e59dfe2c883c2b43bcb1cae7bd2317b7c08fb3388d219aff0b632cc8d5"
    sha256 cellar: :any,                 arm64_monterey: "1a30c82e0f723835771c00820fa3e8bb52318da8cafe402ba35eec34970e8271"
    sha256 cellar: :any,                 sonoma:         "cd6395f3af450c711f0aa7f61975e6345273474f30071efa30b8072b5f9dfc65"
    sha256 cellar: :any,                 ventura:        "963fec7b50bc36a805a0f739379b80a36880697bfffedb65d6742ff66337976a"
    sha256 cellar: :any,                 monterey:       "002e67a68f6dfa79cc9b72f8486d4a98432fd63c6163a5e739fb0dc52dc96ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b9cd950068f633b323c5e51f989b7b34dd45ae8a06461bbd5ce1adb4f60a58"
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
