class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.5.0.tar.gz"
  sha256 "3ecf5ffe9c442cd05a79e0e9e7797a2bacd2977733a3d53555ba6fa54936f7b3"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4dc068504cbfcba9f16009e998949395afba22d866e1432bcb91c2e67b97bfbb"
    sha256 cellar: :any, arm64_sequoia: "e0ceb69835b518144123ae68297fc26fdfe0df3861aaefc38ce12576839bb0d0"
    sha256 cellar: :any, arm64_sonoma:  "9b88823ec957f06c28948b6d040657096df17d186b75cb3814281f7cc46207d8"
    sha256 cellar: :any, sonoma:        "9478062d9afa5a15f1cd6dc1ba307e6a6e621792f79be163d1a03e99d2143036"
    sha256 cellar: :any, arm64_linux:   "0b9540bcfef0df728a3e45f98c734fe6cbb1e61de5325bc84bd7ac6968ce99c0"
    sha256 cellar: :any, x86_64_linux:  "3ce27f63717432c439310b14bc1c1ea4e1cf6e54bcc38546cbfcd844ecb8ae75"
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
