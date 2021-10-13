class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.19.1/mongo-c-driver-1.19.1.tar.gz"
  sha256 "1732251e3f65bc02ce05c04ce34ef2819b154479108df669f0c045486952521d"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "de4bbc7532fd196b9fba738e8b17edfc0aadb6bedbdbd71833a7ef1b255eec16"
    sha256 cellar: :any,                 big_sur:       "204323f9b79875608290cd49fe8a8bb81eeda5ea1b1fde92c76a063e9f19d1d5"
    sha256 cellar: :any,                 catalina:      "45beeed3b08061903197d2bcdf40febf951e8782b95e0a7df321fea0475f9e54"
    sha256 cellar: :any,                 mojave:        "07ecdab24599574fb8ab343665902cf01fcff1535a584cf26c89107e2797b948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661526256b04bb4eb936a4699b18bfa77ab8c241f82bc35bd79ba49bf44570df"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_VERSION=1.18.0-pre" if build.head?
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
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
