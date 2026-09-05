class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.5.2.tar.gz"
  sha256 "0a48672e36cad2a1450811b6129b2acdfa5d8ebdd93882f351fca274b2e2660b"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea165676bb9ad648c5d6040c2252f129ecedbc074b87efe13b3aebdb791a6d23"
    sha256 cellar: :any, arm64_sequoia: "e946d3be307ef3bc37b472fe3ee024d8bf598114a94d5765fc3ab9f2f7ba1f1f"
    sha256 cellar: :any, arm64_sonoma:  "dd3fdf701788624297d5801e2841f218344bab21200a0286eea8d7d046554109"
    sha256 cellar: :any, arm64_linux:   "6c1c2951d9c40f5e70575241407675cdbb29f61b0a2783e8d9813ba949e9a400"
    sha256 cellar: :any, x86_64_linux:  "4c5096dbd7c1e8f8f0fe351ddc672a7ab35a8479d7271718b127d4febc52ee09"
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
