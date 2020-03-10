class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.17.tar.gz"
  sha256 "11eb170fba2a974c488b27a7759bf8f31780dfaccca75b6da668c8a43de75260"

  bottle do
    cellar :any
    sha256 "2ec63f90a86c7f733ad523dcaa7bf66d3e73d18bd12499f0585455b9527c275d" => :catalina
    sha256 "1183bf174fc3413e7812c7448206136d35c803a4da1095ce9bcc1134adac8487" => :mojave
    sha256 "6fb75a7c373ba765b95025f4de359ac6ca8111f7d363685cb3f9df4b518aec17" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    args = [
      "--lto-thin",
      "--icu=#{Formula["icu4c"].opt_include}",
      "--extra-defines=U_USING_ICU_NAMESPACE=1", # icu4c 61.1 compatability
      "-j=#{ENV.make_jobs}",
      "-y",
    ]

    # Build dynamically for the shared library
    system "./build.sh", *args
    # Then statically to get a usable binary
    system "./build.sh", "--static", *args

    bin.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/libChakraCore.dylib"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
