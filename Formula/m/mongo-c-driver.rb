class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.5.10.tar.gz"
  sha256 "797fd25318ce105e804187e9451590bb3e136fc3502743807fe8a2a5396b2b95"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "428e12a511893e522ca28ef5c2a04f9287640c5c9fcae8ffd993fbb17e9b44e5"
    sha256 cellar: :any, arm64_golden_gate: "8c4b552e935b95956f1b9d5782935e33c1b1ede3fd533fb8683d980aa594a1b7"
    sha256 cellar: :any, arm64_tahoe:       "7f8fb4ef442691a77dec61e519c22bcffcfe331dd81805866c26d0d0f2756e96"
    sha256 cellar: :any, arm64_sequoia:     "c8f92ea023de654db29f5c224789000bc2bd25b9e21885babb8d706d8d94524e"
    sha256 cellar: :any, arm64_linux:       "dd5ffacf7322d565b83b812fcbcc2404374c11b2129f73d0330df2b06d6294c8"
    sha256 cellar: :any, x86_64_linux:      "f5861d6ac7416ec2bc98e2b611484d8f43b629c6b1a797f9280cb41152d928d8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@4"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
