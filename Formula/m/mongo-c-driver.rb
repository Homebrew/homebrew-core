class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.29.0.tar.gz"
  sha256 "507414795dfb24ddf1a418b155b57459d8cea1191c7f0fcd8b826acf5400343c"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4f21fedfda0eebce42de12b02eae5de2c55083e3d70dc002ed410a49a6b87a1"
    sha256 cellar: :any,                 arm64_sonoma:  "e14103bf6cb5a50ca4211da32503ce496f336d6edd771dd38c250880cb309fab"
    sha256 cellar: :any,                 arm64_ventura: "8fa2bdd4e92144ef5f888c7d2d19dfb76b7f07164d58d45529fd5fcbd8808b6f"
    sha256 cellar: :any,                 sonoma:        "a59ea091aca0c1248893f71299a972b898d2f73cdabcccad961250e79cc397ef"
    sha256 cellar: :any,                 ventura:       "a68cdd701a71286c3b8a17d12f18bc18200d32adb44a2f8421e5e8062604b738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c5490508d63f54720a08c10329d387bf2398c914c240ca9175b66908ecfae0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
