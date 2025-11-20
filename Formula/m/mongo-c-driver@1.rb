class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.6.tar.gz"
  sha256 "49904f5757fc6fd3671e554b93602907505a34c80365f4dceda3b5da481f0770"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8d80b35837d53c74e36c55ceabef1d2181aa578e84f9d09cc06af4fecf75f9a"
    sha256 cellar: :any,                 arm64_sequoia: "ec209b833df2081a7b827b57439b553f48eec456ce5caddd3044af98a09052ec"
    sha256 cellar: :any,                 arm64_sonoma:  "976ae65d3b2ef97381678f5435e34327ce646ae5ba99cbb9791d0198b6e79cb6"
    sha256 cellar: :any,                 sonoma:        "2ae6577ddcf763700531ccc717c14178b11d2ff0131a5d62a144cd0cc5defbe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ca65a252f47d29c0f18e8d0f9047c33d44e1e7d18594039700b2c8af841686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2847d983bf25ed028d429787b778216f3dd64da70b4e0d3e748797c9c44282"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
