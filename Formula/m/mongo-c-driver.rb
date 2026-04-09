class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.2.4.tar.gz"
  sha256 "85b58dc70245fe32eab47f8c870d9bf323eeaa4f9432c6eb4b3dedce57fd4911"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9dd29b715b143e461468f30ad2f971c9c274b37840690cfbc9f8e50268f965e"
    sha256 cellar: :any,                 arm64_sequoia: "a524d9cd92de59ea303f76bd00be1cb52bfa899b2832d555d550a56f727db5e0"
    sha256 cellar: :any,                 arm64_sonoma:  "f1ca6a280d1ad3ac205d79be07fad4b35fb446e73d01fef178807a06be80dd7c"
    sha256 cellar: :any,                 sonoma:        "d0c43321baa7dad596dfe67fa47c4ad6ac25cf48638125b8a4df2c49e166171b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32945843047e31e91ca580dfc5a2b88dd214809d57ff018d8f0779172675e2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11207fd4e9215b5dbf669108edfad3c12e43af62187a20509f6b98f14f017c7a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
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
