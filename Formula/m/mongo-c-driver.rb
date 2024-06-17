class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.27.2.tar.gz"
  sha256 "a53010803e2df097a2ea756be6ece34c8f52cda2c18e6ea21115097b75f5d4bf"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71b0ed3dd1d70979fa9af245f4edbec5c3b928675f3c2ff7fc42638f5435317c"
    sha256 cellar: :any,                 arm64_ventura:  "c75ae51c343d49c1bf8afa124427bb43945ad09b877aa1610ebe2311631eb055"
    sha256 cellar: :any,                 arm64_monterey: "0aa66c120dc4237d38c233312e3c3823567a7f0366585536fa2a9bfd269e8e52"
    sha256 cellar: :any,                 sonoma:         "6382d5e21bffdf238ac8ad0680ef013b14578e82d7a3d9b328fb828c6d250ca5"
    sha256 cellar: :any,                 ventura:        "9119176b4f145bf3fe8a1c0ca6f18767079e913f889504169d674dd5f8225daa"
    sha256 cellar: :any,                 monterey:       "2944a84562985877e815a9ea8bf00b5cf6cc09a84a3ba3ac914e7d3092d1b280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dfb499e0f84e85180f70aba376e3a1e8e23506a6186c89360272c08a53dd75e"
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
