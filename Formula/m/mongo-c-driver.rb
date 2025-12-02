class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.2.0.tar.gz"
  sha256 "bbbe7718f0c2c264083da15a132f877f8286d31c9f5bba15605ffc58c0bc94ae"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d29a0b4224684759851548116aa3074881767f8b45b6ec16396f7b8cacdc00d"
    sha256 cellar: :any,                 arm64_sequoia: "a54696c096b9ed3ed9520e6b444cd2598a01ac60f3321bae0f1574c5f236ddfd"
    sha256 cellar: :any,                 arm64_sonoma:  "d47ed4eb501fd2d3247a7f71671b3cfbaa9109c91b4642ab28ad14ded18473f3"
    sha256 cellar: :any,                 sonoma:        "51e16f7a99c86d544f908e611292fa53f0e6a6aa22d0d5432ec0ce5c6bb3fb5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8d59f991f30feffcddd3fa3c75c26acfca22a001d9cba8fb60ab3d06be3d954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2df8a69e44caab60f02e447d775ae76cc63285a7cb13b57ac2e5229371ca39d2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

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
