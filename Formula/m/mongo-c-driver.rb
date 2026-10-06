class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.5.5.tar.gz"
  sha256 "0461e130ed73805fc1aff4fb7b7182e88dc1f86fef8812276e4f84e30c07aae5"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "270d938db3a45e9cfa3c1bef021dc360d98feea066cad34fb1125218c9598f9c"
    sha256 cellar: :any, arm64_tahoe:       "af790990dba0114bb7e31c50ccdfd8ebe3a0d5a49360ab8a06120712dbdf5099"
    sha256 cellar: :any, arm64_sequoia:     "291ac213926fafe8657ec41d907a9f31f0afab874aace0fcff80667a84949286"
    sha256 cellar: :any, arm64_linux:       "c40124a2574c4d91e6cdebef8300a70b5710e49c04a2d7509eefca976010e66d"
    sha256 cellar: :any, x86_64_linux:      "9bc5e607baea214dd272231ad86d47c2fef48763e29e997e3207f74929b0af2d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@4"
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
