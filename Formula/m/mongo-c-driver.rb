class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.28.1.tar.gz"
  sha256 "249fd66d8d12aac2aec7dea1456e1bf24908c87971016c391a1a82a636029a87"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab2f9e66d05834a9c66a1ab3de464526d533e22fb0b7c1cbc33bf10614037968"
    sha256 cellar: :any,                 arm64_sonoma:  "4083a278c0a6e3e8c72f42e65ee15c7ac0ecc0b440f8e37d966aa1a2c2ed0fa9"
    sha256 cellar: :any,                 arm64_ventura: "80838b56b6b99cb13b0bd9be57710fa8dbc11c3ba84d73748247601e8d65a13c"
    sha256 cellar: :any,                 sonoma:        "c630e632168c5d49998e27b968b9764e28b367469e686fe6726b0703edae7b32"
    sha256 cellar: :any,                 ventura:       "d2dc32d0cf4362f5293efa63a1d9bc902a0f975821a3b4eff4de270cc177fbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bac1a29f1a24a78879295f88e741006923d24d9238b2e715f8888e80e2eb055"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    File.write "VERSION_CURRENT", version.to_s unless build.head?
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc
    system "cmake", ".", *cmake_args
    system "make", "install"
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
