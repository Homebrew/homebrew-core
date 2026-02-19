class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.2.2.tar.gz"
  sha256 "ac04c7125f2eae0288f11ddeb1aa76fd318df7228ff3484aa9b415aed52665e2"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "41deaee887a2a4025e2ffc1eec0850f16bad3d938b2ed5af9b5ebf37c3eca424"
    sha256 cellar: :any,                 arm64_sequoia: "e478bb4f20cf0edfc25b63220c2106938d48799bba0f3d4b217f6d21db96f3fa"
    sha256 cellar: :any,                 arm64_sonoma:  "327c2270425e6310b221ce3482cb01635df8f1d1752088ac1c9776d02b386a59"
    sha256 cellar: :any,                 sonoma:        "3e523d70606ae88472a112fc800cc27797d845856ff9b6bbe1f025aa307252a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46b0cc67878752a770b7ce9586e94f79e765c7aeb984a620ea4e1a86b4b04fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40c0200ce233379683df5ea08ce21b47f999d47375201ea0eadbda0a3b945e7"
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
