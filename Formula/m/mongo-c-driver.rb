class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.3.1.tar.gz"
  sha256 "a3fc6ebf73e7a26482a5c0f86e4011e4c1f1d8f5bd16ca9ae7c732a8e6965490"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5e8237dca2e20d839451536ffdf1f100c4799c2e0df4c424876742fe068bdcc5"
    sha256 cellar: :any, arm64_sequoia: "1e7a30eb03dc9b5e0dc971b0ce3c674f0d6350284abe0e6e5a715caffb22b109"
    sha256 cellar: :any, arm64_sonoma:  "63a7efb6facbffbf48a2ab6ebfe92cf19ad7d800bb39dd10c9d29036e33402a2"
    sha256 cellar: :any, sonoma:        "135248aaeb690dfa01469daf82254f29c90c1ecf9958f14828e718b095bdeb15"
    sha256 cellar: :any, arm64_linux:   "81b8d70d348a0738f6c21149558f2ba5f84de7fe61c384a482071d35fcc6a95d"
    sha256 cellar: :any, x86_64_linux:  "a5938a0b3db2bfc821f555c87b0d5aadb0501b4e55fdd16ad82148b8e3e90454"
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
