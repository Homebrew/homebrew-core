class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.2.1.tar.gz"
  sha256 "de10b35ad8362eaf6951723117f90c3c171548da05980890f7e5f60aa56f8d24"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91b814c83ad34c45cc0ccfd23246d982664301193ca0d27596050fa2932d23a6"
    sha256 cellar: :any,                 arm64_sequoia: "dda81c7482c96dc7dfe7e5695c37dc6fc5dac89f8e9a890e2f3187398eefcf23"
    sha256 cellar: :any,                 arm64_sonoma:  "2b80e4bd923221f10098a423c68bdbacdaf581b558debc241cd6c58300cb4a4f"
    sha256 cellar: :any,                 sonoma:        "6d0eb5e51731fa75235e996e3c8549b06ce75b0339b0d75429790fa006ac138d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ba490162f0a908cc4f1654fcc4cada11b95fdbbdc048b0279fe967bc1bb985b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a165552f0541590e64aebf561042b9ff4d0b744cc7ea81425c724d4c3777beb3"
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
