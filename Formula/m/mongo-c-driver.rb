class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.0.tar.gz"
  sha256 "be937a0e60be4317640c309acfbf01ca3cdd02afc54a318bab0f02c941fbc485"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d311d8d9efe27a1b0b5e350c7a0afb3939b18da929e0945eec3aabc3a1fe0d6"
    sha256 cellar: :any,                 arm64_sonoma:  "bbc52351ce74b806166eab77c95e773f1c7860adf9a09086188358f7fb80a3c5"
    sha256 cellar: :any,                 arm64_ventura: "a6eabdec7df06fa1b1014d6bca756ce542f8f1cda080d9532a84fa35a5e0fdd1"
    sha256 cellar: :any,                 sonoma:        "67a23e7ab857c2893247cacb2cd83d6fb75541eaaaea1d3fdb0a2ec0af97dd58"
    sha256 cellar: :any,                 ventura:       "6856ea8d8606b9d3d0b7cf89da0057c5c0faced144b5f9e3977d661cc376cc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14838162a9fb52c7a922667d3a88c958bf7425f0daa531fdd1f8d9ba8c8e4a15"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    File.write "VERSION_CURRENT", version.to_s unless build.head?
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
