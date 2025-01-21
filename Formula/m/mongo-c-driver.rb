class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.29.2.tar.gz"
  sha256 "7437ac6e71a79bc60822797d16a92471407cb1e31ebe4295907ee6651abaa71f"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "142ebf779d632523389fa69a958fa37932e777f50b807d47033fdaa8a9c66d7d"
    sha256 cellar: :any,                 arm64_sonoma:  "b2e3f758a6210927e514ab3406e5af84f744597c1685e8f2d812009f4025346f"
    sha256 cellar: :any,                 arm64_ventura: "bf4ac7c43dea5810dcfce7256bcfdaef9b338d7e935904244da7eb8c478d7f4a"
    sha256 cellar: :any,                 sonoma:        "c6c5e05d652b584cff38b362571dd552c11103b72d282bceacf7c0c2ee2fad3b"
    sha256 cellar: :any,                 ventura:       "8cb3f752588e7eab3161d6710b804aa26971acbdcf83ea0ba92e26e1fef458f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d05c37e4bc021569541ba0340d0cb080775a93a6dd9bb7bcfcb9b68a7f10d6"
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
