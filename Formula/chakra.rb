class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.1.tar.gz"
  sha256 "569e6843748253d5c7c8082ad5cd49815c5b224cd845d5715bfe4d59a74f8113"

  bottle do
    cellar :any
    sha256 "4d8d0b542398ca8a510374e4cb6702f1e9bbc0533cacf589088a6b312caca879" => :mojave
    sha256 "e7f1fa4ced218d0069e019358e63394ff0515f4489bcd74c49d45351e15ce7f0" => :high_sierra
    sha256 "fc1ad91a954263720f3fa0d47e367208a4d7791bf58d922e6dc40f5de0cae72e" => :sierra
    sha256 "3f6ee063e19dc68ae05df4476b12272cc170369bec5ec152b3bded2b7cf7c89b" => :el_capitan
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
