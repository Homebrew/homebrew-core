class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.1.tar.gz"
  sha256 "569e6843748253d5c7c8082ad5cd49815c5b224cd845d5715bfe4d59a74f8113"

  bottle do
    cellar :any
    sha256 "234a9df9ddd7268fd71d0c99659f1322888d8d823d4502b2b96600b65119e09a" => :mojave
    sha256 "72dd19efae550c952c87a6c3ff3e707eca6c9653525d6d7968deb692fe55ef7e" => :high_sierra
    sha256 "dc1f855f6c602663c8ccaab1d5a59469f92c3648c8dd7043168a4309bd48494a" => :sierra
    sha256 "9d6bc1e1af76bf9752e6953b99b8bc16273fad6271f091aa80b8a18ae0181cb6" => :el_capitan
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
