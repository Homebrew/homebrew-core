class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.5.tar.gz"
  sha256 "acb16b3a287a440cb79e2bedbad829feb00e4cf2279123cce5c602480765b7ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10b1a94d72b7d1c7da6f9bb17e6608e00dbaf12735ba782af30d96091f725d33"
    sha256 cellar: :any,                 arm64_sequoia: "d5379448d391b847c9414d306328d9a5a3cce16974dad5b02776683fa9e817b9"
    sha256 cellar: :any,                 arm64_sonoma:  "fe5ebcf4a5e2db44c6788918c7a4f8a80f2f670e230ddcbad3e3672347aefa66"
    sha256 cellar: :any,                 arm64_ventura: "254662b9e775e1731b72eb557cb5736ca80f6e29540928dedbfd6f0cb9afd1d6"
    sha256 cellar: :any,                 sonoma:        "c279c07c638930ee60d5015c348a8c10eb0385cb13c8f6ea72d2f64593b3a4f3"
    sha256 cellar: :any,                 ventura:       "6364f4b25414cf5aa9aeb855f12e80be8e26e588beca85e0a4742660db13b169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3caa16aabff46ff4d347319417c53def607430e7a53c6d10b1e6464c3045e75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529c5124804c14d6319887a764bcc876b7493951aab7285d1f7a262f80c167d1"
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
