class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.8.tar.gz"
  sha256 "11f87477efe7aa9cacd9fd18872eb7e629adee898af627f670d1c2e2911b4670"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "631afe5e9a69bdefc9fc3a7bc6a8594092d95992dc69576911450c1e4e05ead9"
    sha256 cellar: :any,                 arm64_sequoia: "e63f93a4b2e8a25bdbd8296552f7d2f5068b1c26d2da377bc850e5b6684527b7"
    sha256 cellar: :any,                 arm64_sonoma:  "e37e0f01f42b7bc092f61f666a73d099db68c7befcd055cec1c2d7030cc153b2"
    sha256 cellar: :any,                 sonoma:        "5fa45af42b827d347807e64531ed1e2670d9496479d9c921813d16dc2e3e766e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb745e0367542478306534be0ba3cce7f48bbb259b36ffa5dd597d55a271270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb8bb4be9623dae26fe356cee0e366cf5e26951e25074b62563bb97ab89a0839"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    File.write "VERSION_CURRENT", version.to_s
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
