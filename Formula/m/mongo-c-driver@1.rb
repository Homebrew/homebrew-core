class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.9.tar.gz"
  sha256 "ff6e4c439c2da5d2dc32f4a22fc13509bc60700103eb8fa8f516917fe83ad0d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "01ea07e4781de9fa9efd3b9655d7be8f94bfece0991e18182b924afe7a1c8ebe"
    sha256 cellar: :any, arm64_sequoia: "6985aa18cf09faa18a7fd21525962ec90871b8ac78a069824a6224ba55cc5975"
    sha256 cellar: :any, arm64_sonoma:  "be82049294de21ff6c6311497bba223e33209c2d1ec73acef7ae4806b98b85e4"
    sha256 cellar: :any, arm64_linux:   "5f44504c5ebafd15a0bbbf8079d557a1358ea503a8bba1449c28f9e488161a9c"
    sha256 cellar: :any, x86_64_linux:  "41d606c19443331de72b3d325e494ccfb63129d2a54bbae92660ceb7475adc27"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained
  disable! date: "2027-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
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
