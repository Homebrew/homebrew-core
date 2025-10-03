class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.1.1.tar.gz"
  sha256 "faac3cdc38f66d14ecd93d54d316ba30232bba65543aad35e335e9adb17cd17d"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94bf32aefd3282c12a70bc413c728a86c06ebd27ca4e74ea2587186a9c0a1513"
    sha256 cellar: :any,                 arm64_sequoia: "6f91f08688319f67fec77ca921c28f8a3210a693e7fd2008d8e19bcd4705eb6d"
    sha256 cellar: :any,                 arm64_sonoma:  "7502bd5fd14fa1020a5232388492ba31821afbce1ce7b3af7ea077797df8712c"
    sha256 cellar: :any,                 sonoma:        "971e12a51cea0521b05322c1df38054e1d376d5eff40e42defab2e8b12c23cb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "019f708b2d8606a04baa38bd19821e73faa87b4db57dd7177be6e31eaef5e552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6292da0444d08dbe61a643eb44c7622c5b771584e2ea0a927e2dfe56623787e2"
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
