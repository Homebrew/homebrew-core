class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.4.tar.gz"
  sha256 "03e484ff8b382ad0ddf03fbf70e88a82292d753ac2fbf37bac67c2860117b0a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11ec4903de5e8816f1e3670644995240062bf6fb7f55a17c76a571b9b0576f51"
    sha256 cellar: :any,                 arm64_sonoma:  "679d591289a2da855fb9091c41518207af700dd1ea888be468707960c228f705"
    sha256 cellar: :any,                 arm64_ventura: "de9c0bd3f75edf2fea59d2cccf791980ea7c0fa0cf6dfa1aa6254584e9740595"
    sha256 cellar: :any,                 sonoma:        "aec28e36191558d3509704146f72ea9d3f25b61f1c555cda35ed8a670cb0ea6c"
    sha256 cellar: :any,                 ventura:       "2c05d4458319c3e7dede70c30043219e10a28219f6f0c544c98930cb81594c8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50c902b7643871073f781dd801c0f99bac8f9d966ead902cd3f594131f6b562c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9009dc4549e27ad5c5db699f435ed379354c5da6aa3ca69a0b1ea144002b97c"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
