class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.17.tar.gz"
  sha256 "329caa3cb26bfb5c37e439eb7f8066aa8bcdc264f34637f3f58e439da43fa03c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f12712c273c336c1aa59cca74dacdbd36cbb7d54a00b301375dec9a7c749a200"
    sha256 cellar: :any, arm64_golden_gate: "f86ca04341747b174837a6852270d531ee5aed94cc9db37eb62b230391cf5475"
    sha256 cellar: :any, arm64_tahoe:       "dd718bf8ecac947f4449e2c85a7411b04794ea72a333ce34dca036f1ecf08150"
    sha256 cellar: :any, arm64_sequoia:     "fbf48de8e803d527bd76ea5d50778d5f69ed3672c8e5855261a0bed83cac8bbf"
    sha256 cellar: :any, arm64_linux:       "ffb9de53965bd0c6c14b80afd15a4c1e69de64557ce416438919a92379639420"
    sha256 cellar: :any, x86_64_linux:      "55e7b506e7338c5a657b58e0d92a6833836445e9e710b9029c745a1dd544608b"
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
