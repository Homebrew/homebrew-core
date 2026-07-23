class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.3.3.tar.gz"
  sha256 "1ca94a2f706e8eab5c9478f1725c69bff23d2692e4a1e476bce093245c8efd5d"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d08207cc98adf98d6b39dd297f8b87d566a48a351fc0cb64acb5cdf97375668d"
    sha256 cellar: :any, arm64_sequoia: "90ad37afc5412e3406138da2871847e9847187071c42473eee65a6dee95177db"
    sha256 cellar: :any, arm64_sonoma:  "274be9507f9c4e98747528470e8685eed7419abdc4521fb35a472ae94d3e8496"
    sha256 cellar: :any, sonoma:        "c9db5ba6b8e639acf3e8b079372ff4ea3c9dcc98b9e8d87233a04dfb7b6efdb2"
    sha256 cellar: :any, arm64_linux:   "78149a987c71a4521d255b6169b6324ad8eeedf5d82468f38207e6ea21e3279c"
    sha256 cellar: :any, x86_64_linux:  "f62c163bea10866a67842b9d5b155db3aa61f0599e0f6c36958fcdd8bb26c8e9"
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
