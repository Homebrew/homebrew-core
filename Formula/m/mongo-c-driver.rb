class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.1.2.tar.gz"
  sha256 "df1280403326611dd3d8277a93be2301fae481c68cc749bb746d7bea81417ee9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3540bc4ef97a6e41214eaaea4b7365605b5107c387466bd566d5cd0caedfdfbb"
    sha256 cellar: :any,                 arm64_sequoia: "88148e3d21d7c5f52e3542d40d68cee3d7fced83798219cc58db1c57acf15802"
    sha256 cellar: :any,                 arm64_sonoma:  "d3a96d3c935806374bdfa503e3ad76e6a522f7bb217eee94735ef08f215d3658"
    sha256 cellar: :any,                 sonoma:        "cde45f9942f638ee4dd5776dc9e170bf947d5b4f225aa9b725254112b9919880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a72eeaca5e4664d62682f745056be87783b02e2f39f8aeca9d8f44f8079b67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ee224052b1dbb7ab98167d37bcc2cda3440e0db96e7f345eb9a4bfc7fd6b03"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
