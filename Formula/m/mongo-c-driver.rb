class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.3.2.tar.gz"
  sha256 "030bcf814856a06f39d0e49d4b4420b28dc851d87e2a86f12f2d2ac50edad9d8"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c972662ae4f5f30a3f9690462f2946581380f3dd545d1f8556c2aee76266a12e"
    sha256 cellar: :any, arm64_sequoia: "3ad45190b7e79f6afba9b4f18755d7a71f8d5af9664934a71df216195d63fe09"
    sha256 cellar: :any, arm64_sonoma:  "c4e1653ceafae912711b5eb911ddf994dda544dd8aa4add9194a6834f38492aa"
    sha256 cellar: :any, sonoma:        "ecce1030680e8291960f967dff9919e7cfc9f9c8b1df81959b614395036fbc82"
    sha256 cellar: :any, arm64_linux:   "f40066f5e2e84a14c88c039a06765b747b883ed5970f33d81dcb8591ce8c3981"
    sha256 cellar: :any, x86_64_linux:  "30e7c91d1c84e3d7aa12211c4f3cd1924ef1c4e817dab38ae8e08da8442cb573"
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
