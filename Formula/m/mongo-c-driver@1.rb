class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.7.tar.gz"
  sha256 "addac1f20d280a1a55fdbcb73edf929af74b9768b61c92d77703466f51d6885a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "da30b69d4cb4b2be0762d80a9125aa34c2256d03670d7a31e7d2b12de1fa691d"
    sha256 cellar: :any,                 arm64_sequoia: "dfa78f2a5d9b3abcc26db837de8b5e28bb488b6916742bcd39a4244a7bc1fcc7"
    sha256 cellar: :any,                 arm64_sonoma:  "6140f3b7609c4425695ab49aea82e513047a5d409a557f85769052e9e949deff"
    sha256 cellar: :any,                 sonoma:        "693819b2185f77e0f6c12cc30b1e6d340785574e2449379b4944a2b531bc5437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8fd8f18d4e78ac98ae0e61c0a6e3e4bd829d8ea00d0b753fb667474985cd354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604c322948f8ac122e50970d8af4e8b1f2be763eb119ccbc6a6a226121d4bf70"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained

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
