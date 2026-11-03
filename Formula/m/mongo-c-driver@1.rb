class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.15.tar.gz"
  sha256 "d449f570b99dcf12bc7561c5a295fa022dc56d77cb44c6811fbe7a46b5224387"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2dbe634a1db9114262585511886c3b2347735faf52d40f45ccba18f86780ab2a"
    sha256 cellar: :any, arm64_tahoe:       "9b83bdb8622f405255b4e8186b3c31d59aff7b848e03f264f408ce6c28fe8588"
    sha256 cellar: :any, arm64_sequoia:     "3117153b95a669af1cbb49cbb6d0bd81e3f856e8508b0528b624402e5ef71684"
    sha256 cellar: :any, arm64_linux:       "2fa44307d64b1879398140410442e35acb3d446429521f112e9ed3829c15f6e9"
    sha256 cellar: :any, x86_64_linux:      "288bf5d33147c2ddb4b5b4f563f50d6b281f30bc09f50fc2c2c78571cff2eea2"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained
  disable! date: "2027-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "zstd"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    File.write "VERSION_CURRENT", version.to_s
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
