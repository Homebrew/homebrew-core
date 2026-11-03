class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.5.8.tar.gz"
  sha256 "824718c8cff845c866038c7c9fc988a172b9d756cffe9fefc4ca9073785374c5"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a63dd9c7b1a2b7a4ce2b792272f44eb2f6a97f998f287c4ccd7165b4823e04df"
    sha256 cellar: :any, arm64_tahoe:       "260247752c7d60d2938b4afe920606eac0456c2e8ffc2f672677bb1c8a237d60"
    sha256 cellar: :any, arm64_sequoia:     "21f4f51bff1ed19aae940dff12f866dde297c414749afb2c8f641d2c891981fe"
    sha256 cellar: :any, arm64_linux:       "3a7b2e7498b10f6aab7d75c6204a15f2f559bd4d80b25a784d8b4ec867fc9fcb"
    sha256 cellar: :any, x86_64_linux:      "f893327d05ac7157a6cc3229ef286118d50308f108096cc125b4c3df7a66dca5"
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
