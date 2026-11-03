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
    sha256 cellar: :any, arm64_golden_gate: "b65cf5197fc0a015adfd871fc56b9e5155f1e952574f4325d6a743dad9645268"
    sha256 cellar: :any, arm64_tahoe:       "e2afb97706ed012550ab86ef9ef961a405e05abc086bcd69b8ecbba736ab6114"
    sha256 cellar: :any, arm64_sequoia:     "ea3f356cde1b8821bca42540610c1e2061b534a6ba7aeb596c621d0a4ae2d4a0"
    sha256 cellar: :any, arm64_linux:       "cf8d309b454eac0cf31c64cc1a681f28960736452ebc6144e9fee10d359ff196"
    sha256 cellar: :any, x86_64_linux:      "d3b8c06b537957336b1c4730aef5d3158d4e9a678781b77b8e82cb2899163649"
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
