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
    sha256 cellar: :any, arm64_golden_gate: "25901c1137bda42621d52314d6f29d2c00f5174eab989c6be8d264569909b752"
    sha256 cellar: :any, arm64_tahoe:       "2f5d35c45b20e455feda4ff8fb8890050382aca5e1c16509103f7e32b18ae721"
    sha256 cellar: :any, arm64_sequoia:     "06316dbacf550fef483d492d8b024a61481f05a95eaf3f337ee9b11934cf1eb8"
    sha256 cellar: :any, arm64_linux:       "60f6db0a8c1e959b914cc1776d3ee2bdb0b048bde23771b4d9f65f7d565d698a"
    sha256 cellar: :any, x86_64_linux:      "5adb202c98e167b2b76cd57cba13dd39bc7fc25671307e5e89f4251527aa7749"
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
