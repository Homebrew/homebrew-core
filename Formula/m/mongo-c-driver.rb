class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.2.3.tar.gz"
  sha256 "5d725d488bf26ae61403dca4c988d49f10814ebaaee8fcf4342e2f89a6e06410"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3016f10623524a930a61bfbd9294e5ebb36630b42334c184c794300ef2b105ee"
    sha256 cellar: :any,                 arm64_sequoia: "73a4d1db6fbb819b4203bce5797dc364ad0a203a30d6bd679b2405bb893f18bb"
    sha256 cellar: :any,                 arm64_sonoma:  "07c266cd3677d3303319d7eecdda0aca16c8faea241abbb5b234d5e15be13d9d"
    sha256 cellar: :any,                 sonoma:        "5d847879848b2971abda65cb0879780dc09b2a0135d04378d37b277fa53258d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcbe2e3e57f59bd275d7f60d35af192cb9e3c1378104b919d633e565c28273d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09416ece64d234071232cb64cb63cd34d8ce8df195a521e62fa970917e4f3e28"
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
