class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.3.0.tar.gz"
  sha256 "0edd0e143af77861309d59c5c029d2408df7348c429c5e1f483c7ba449cb35ce"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49e03cb97bc513a0e729604fda55de40ed5d712914b4f1c9bdd5c358570d2e36"
    sha256 cellar: :any,                 arm64_sequoia: "f04f48be920942ce4010b585d4f55a1b56219dcec8ece7ce7b19ff3a4d0a3cc8"
    sha256 cellar: :any,                 arm64_sonoma:  "0cc93ceece73967a24a740143e154bda2aad3038f4414070908996299c0d725a"
    sha256 cellar: :any,                 sonoma:        "baeac8488db093b88e23a03ac580d3fb2f00da5a69d4e4e3c698f31ebbe8b891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73cdc05c79fd9906b16f5ff29efb464a9df1d88f4b068e74ee4edcad69c8a3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97aac3e9301f693aaa6345be9ceab4355e1d47624086cbc56b6afa8e1b639cad"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "zstd"

  on_linux do
    depends_on "openssl@4"
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
