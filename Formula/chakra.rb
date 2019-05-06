class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.8.tar.gz"
  sha256 "e644d4ff278a5460301b6b55a3f69c24fc3e910906f955c41b651472905002f5"

  bottle do
    cellar :any
    sha256 "c8165e90a56a7265bbb7e1f9f53e7456a53f23457d015a02db1c3641beffdf1d" => :mojave
    sha256 "180af0ba8db359151124990570b27d37904fc653905d637f038ac0584089b057" => :high_sierra
    sha256 "a3778e9e81da4d3402f639ca68a37f4c561ede9805caa21c42f29b09fbf09ede" => :sierra
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
