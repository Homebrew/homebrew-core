class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.16.tar.gz"
  sha256 "bdbec42a6bca29b0386469a9e5eb21d823ecccd65274caf1faec0d3667375f87"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "37400ea2ebc8960f281de8006ffa0c9494fc43468372abf26b857913c0de8f14"
    sha256 cellar: :any, arm64_tahoe:       "47bd542e86fa48a501b53f5d99c9685cc49949ba035da1ef3c11a293e55482d4"
    sha256 cellar: :any, arm64_sequoia:     "cd419d0b9aa4c355850188c89b27fabddeb666e2ad914fee216eb529e08f54d3"
    sha256 cellar: :any, arm64_linux:       "1c4e48700e99c9fe2ac24f42e53a301031294ce9e0f7eee4798fb9b54abbb394"
    sha256 cellar: :any, x86_64_linux:      "b4d4a4dd41659e597c65afa1e8c7fb4d26dcadb33b401c2b3cb14427f6483224"
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
